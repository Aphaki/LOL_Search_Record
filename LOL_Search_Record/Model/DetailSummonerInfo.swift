//
//  DetailSummonerInfo.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Foundation

struct DetailSummonerInfo: Identifiable {
    let id = UUID()
    let icon: Int
    let level: Int
    let summonerName: String
    let rank: String
    let tier: String
    let point: Int
    let mostChamp: [MostChamp]
    let winCount: Int
    let loseCount: Int
    let totalWinningRate: Int
    let totalKda: Double
    let summonerInfo: SummonerInfo
    let leagueInfos: [League]
    var matchInfos: [MatchInfo]
    var mySummonerMatchInfos: [Participant]
    var isBookMark: Bool = false
}

