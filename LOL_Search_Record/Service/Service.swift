//
//  Service.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Combine
import Alamofire


class Service {
    
    var delegate: ServiceDelegate?
    
    // SUMMONER-V4
    func requestSummonerInfo(urlBaseHead: UrlHeadPoint, name: String) async throws -> SummonerInfo {
        try await NetworkManager.shared.requestSummonerInfo(urlBaseHead: urlBaseHead, name: name)
    }
    
    // LEAGUE-V4
    func requestLeaguesInfo(urlBaseHead: UrlHeadPoint, encryptedSummonerId: String) async throws -> [League] {
        try await NetworkManager.shared.requestLeaguesInfo(urlBaseHead: urlBaseHead, encryptedSummonerId: encryptedSummonerId)
    }
    // MATCH-V4
    func requestMatchList(urlBaseHead: UrlHeadPoint, puuid: String, start: Int = 0, count: Int = 20) async throws -> [String]  {
        try await NetworkManager.shared.requestMatchList(urlBaseHead: urlBaseHead, puuid: puuid, start: start, count: count)
    }
    
    // MATCH-V4
    private func requestMatchInfo(urlBaseHead: UrlHeadPoint, matchId: String) async throws -> MatchInfo  {
        try await NetworkManager.shared.requestMatchInfo(urlBaseHead: urlBaseHead, matchId: matchId)
    }
    // MATCH-V4 x 20
    func requestMatchInfos(urlBaseHead: UrlHeadPoint, matchIds: [String]) async throws -> [MatchInfo] {
        
        try await NetworkManager.shared.requestMatchInfos(urlBaseHead: urlBaseHead, matchIds: matchIds)
    }
    
    func saveSearchedSummonerDetail(urlBase: UrlHeadPoint, name: String) async throws -> DetailSummonerInfo{
        let searchedSummonerDetail = try await fetchAndChangeToDetail(urlBase: urlBase, name: name)
        await MainActor.run {
            delegate?.dataTaskSuccess(returnedData: searchedSummonerDetail)
        }
        return searchedSummonerDetail
    }
    
    func fetchAndChangeToDetail(urlBase:UrlHeadPoint, name: String) async throws -> DetailSummonerInfo {
        
        // SUMMONER-V4
        let aSummonerInfo = try await requestSummonerInfo(urlBaseHead: urlBase, name: name)
        
        // LEAGUE-V4
        let encryptedSummonerId = aSummonerInfo.id
        async let fetchLeaguesInfo = await requestLeaguesInfo(urlBaseHead: urlBase, encryptedSummonerId: encryptedSummonerId)
        
        // MATCH-V5 - (puuid)
        let puuid = aSummonerInfo.puuid
        async let fetchMatchIds =
        await requestMatchList(urlBaseHead: urlBase, puuid: puuid)
        
        // LEAGUE-V4, MATCH-V5(puuid) 비동기적 요청
        let (leaguesInfo, matchIds) = try await (fetchLeaguesInfo, fetchMatchIds)
        
        // MATCH-V5(matchId) 각 매치들 한꺼번에 비동기적 요청
        let matchInfos =
        try await requestMatchInfos(urlBaseHead: urlBase, matchIds: matchIds)
        
        // 솔랭 정보만 가져옴
        let soloRankLeague = leaguesInfo.first { aLeague in
            return aLeague.queueType == "RANKED_SOLO_5x5"
        }
        
        // 전체 매치 정보중 나의 정보만 모아줌
        let mySummonerMatchInfos =
        matchInfos.map { (aMatch) -> Participant in
            let filteredParticipant =
            aMatch.info.participants.first { aParticipant in
                return aParticipant.puuid == aSummonerInfo.puuid
            }
            return filteredParticipant!
        }
        // 승률 구하기
        let winCount =
        mySummonerMatchInfos.filter { aParticipant in
            return aParticipant.win == true
        }.count
        let loseCount = mySummonerMatchInfos.filter { aParticipant in
            return aParticipant.win == false
        }.count
        var winningRate: Int {
            if winCount+loseCount != 0 {
                return winCount * 100 / (winCount + loseCount)
            } else {
                return 0
            }
        }
        
        // 전체 매치동안 KDA 각각 구해서 비율 구하기
        let totalKills =
        mySummonerMatchInfos.map { aParticipant -> Int in
            return aParticipant.kills
        }.reduce(0, +)
        let totalDeaths =
        mySummonerMatchInfos.map { aParticipant -> Int in
            return aParticipant.deaths
        }.reduce(0, +)
        let totalAssists =
        mySummonerMatchInfos.map { aParticipant -> Int in
            return aParticipant.assists
        }.reduce(0, +)
        let totalKda = (Double(totalKills) + Double(totalAssists)) / Double(totalDeaths)
        
        // 사용한 챔피언만 나열
        let champNameArray =
        mySummonerMatchInfos.map { aParticipant in
            return aParticipant.championName
        }
        // 제일 많이 사용한 챔피언 3개를 나열
        let (most1Champ, most2Champ, most3Champ) = filteredMost(champNameArray: champNameArray)
        // 각각 모스트 1,2,3 KDA 계산
        let (most1WinningRate, most1Kda) = makeWinningRateAndKda(champName: most1Champ, mySummonerMatchInfos: mySummonerMatchInfos)
        let (most2WinningRate, most2Kda) = makeWinningRateAndKda(champName: most2Champ, mySummonerMatchInfos: mySummonerMatchInfos)
        let (most3WinningRate, most3Kda) = makeWinningRateAndKda(champName: most3Champ, mySummonerMatchInfos: mySummonerMatchInfos)
        
        
        let firstChamp = MostChamp(championName: most1Champ, winningRate: most1WinningRate, kda: most1Kda)
        let secondChamp = MostChamp(championName: most2Champ, winningRate: most2WinningRate, kda: most2Kda)
        let thirdChamp = MostChamp(championName: most3Champ, winningRate: most3WinningRate, kda: most3Kda)
        
        // 디테일 소환사 정보 도출
        let detailSummonerInfo =
        try await DetailSummonerInfo(icon: aSummonerInfo.profileIconId,
                                     level: aSummonerInfo.summonerLevel,
                                     summonerName: aSummonerInfo.name,
                                     rank: soloRankLeague?.rank ?? "",
                                     tier: soloRankLeague?.tier ?? "provisional",
                                     point: soloRankLeague?.leaguePoints ?? 0,
                                     mostChamp:[firstChamp, secondChamp, thirdChamp] ,
                                     winCount: winCount,
                                     loseCount: loseCount,
                                     totalWinningRate: winningRate,
                                     totalKda: totalKda,
                                     summonerInfo: aSummonerInfo,
                                     leagueInfos: fetchLeaguesInfo,
                                     matchInfos: matchInfos,
                                     mySummonerMatchInfos: mySummonerMatchInfos)
        
        return detailSummonerInfo
        
    }
    private func makeWinningRateAndKda(champName: String, mySummonerMatchInfos: [Participant]) -> (Int, Double){
        let most1matchInfos =
        mySummonerMatchInfos.filter { aParticipant in
            return aParticipant.championName == champName
        }
        let most1Wins =
        most1matchInfos.filter { aParticipant in
            return aParticipant.win == true
        }.count
        let most1Losses =
        most1matchInfos.filter { aParticipant in
            return aParticipant.win == false
        }.count
        
        var most1winningRate: Int {
            if most1Wins + most1Losses == 0 {
                return 0
            } else {
                return most1Wins * 100 / (most1Wins + most1Losses)
            }
        }
        
        let most1Kills =
        most1matchInfos.map { aParticipant -> Int in
            return aParticipant.kills
        }.reduce(0, +)
        let most1Deaths =
        most1matchInfos.map { aParticipant -> Int in
            return aParticipant.deaths
        }.reduce(0, +)
        let most1Assists =
        most1matchInfos.map { aParticipant -> Int in
            return aParticipant.assists
        }.reduce(0, +)
        let most1kda =  Double(most1Kills + most1Assists) / Double(most1Deaths)
        
        
        return (most1winningRate, most1kda)
    }
    
    private func filteredMost(champNameArray: [String]) -> (String, String, String) {
        var frequencyDictionary = [String: Int]()
        
        for element in champNameArray {
            if let count = frequencyDictionary[element] {
                frequencyDictionary[element] = count + 1
            } else {
                frequencyDictionary[element] = 1
            }
        }
        
        let maxFrequency = frequencyDictionary.values.max()
        let mostFrequentElement = frequencyDictionary.first(where: { $0.value == maxFrequency })?.key
        
        frequencyDictionary.removeValue(forKey: mostFrequentElement!)
        
        let secondMaxFrequency = frequencyDictionary.values.max()
        let secondMostFrequentElement = frequencyDictionary.first(where: { $0.value == secondMaxFrequency })?.key
        if secondMostFrequentElement != nil {
            frequencyDictionary.removeValue(forKey: secondMostFrequentElement!)
        }
        
        let thirdMaxFrequency = frequencyDictionary.values.max()
        let thirdMostFrequentElement = frequencyDictionary.first(where: { $0.value == thirdMaxFrequency })?.key
        
        return (mostFrequentElement ?? "", secondMostFrequentElement ?? "", thirdMostFrequentElement ?? "")
    }
    
    func duplicateCheckAndAdd(aDetailSummoner: DetailSummonerInfo, summonerList: inout [DetailSummonerInfo]) {
        let nameArray =
        summonerList.map { aDetail in
            return aDetail.summonerName
        }
        if nameArray.filter({ aName in
            return aName == aDetailSummoner.summonerName
        }).isEmpty {
            summonerList.append(aDetailSummoner)
        }
    }
}

protocol ServiceDelegate {
    func dataTaskSuccess(returnedData: DetailSummonerInfo)
}
