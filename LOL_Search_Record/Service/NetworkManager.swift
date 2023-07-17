//
//  NetworkManager.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/10.
//

import Foundation

// + UIImage
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    var delegate: NetworkManagerDelegate?
    
    // SUMMONER-V4 - 소환사명 입력 -> 소환사 정보
    func requestSummonerInfo(urlBaseHead: UrlHeadPoint, name: String) async throws -> SummonerInfo {
        let dataTask =
        ApiClient.shared.session
            .request(Router.summoner(urlBaseHead: urlBaseHead, name: name))
            .serializingDecodable(SummonerInfo.self)
        if let response = await dataTask.response.response {
            print("NetworkManager - requestSummonerInfo() - Status Code: \(response.statusCode)")
            if response.statusCode == 404 {
                delegate?.noSummonerError()
            }
        }
        else {
            print("NetworkManager - requestSummonerInfo() - response: nil")
        }
        do {
            let value = try await dataTask.value
            return value
        } catch let error {
            debugPrint(error.localizedDescription)
            throw error
        }
    }
    
    // LEAGUE-V4 - encrytedSummonerId 입력 -> 리그 정보
    func requestLeaguesInfo(urlBaseHead: UrlHeadPoint, encryptedSummonerId: String) async throws -> [League] {
        let dataTask =
        ApiClient.shared.session
            .request(Router.league(urlBaseHead: urlBaseHead, encryptedSummonerId: encryptedSummonerId))
            .serializingDecodable([League].self)
        if let response = await dataTask.response.response {
            print("NetworkManager - requestLeaguesInfo() - Status code: \(response.statusCode)")
        } else {
            print("NetworkManager - requesLeaguesInfo() - response: nil")
        }
        do {
            let value = try await dataTask.value
            return value
        } catch {
            debugPrint(error.localizedDescription)
            throw error
        }
    }
    // MATCH-V4
    func requestMatchList(urlBaseHead: UrlHeadPoint, puuid: String, start: Int = 0 , count: Int = 20) async throws -> [String] {
        let dataTask = ApiClient.shared.session
            .request(Router.match(urlBaseHead: urlBaseHead, puuid: puuid, start: start, count: count))
            .serializingDecodable([String].self)
        if let response = await dataTask.response.response {
            print("NetworkManager - requestMatchList() - StatusCode: \(response.statusCode)")
        } else {
            print("NetworkManager -requestMatchList() - response: nil")
        }
        
        do {
            let value = try await dataTask.value
            return value
        } catch {
            debugPrint(error.localizedDescription)
            throw error
        }
    }
    
    // MATCH-V4
    func requestMatchInfo(urlBaseHead: UrlHeadPoint, matchId: String) async throws -> MatchInfo  {
        let dataTask = ApiClient.shared.session
            .request(Router.matchInfo(urlBaseHead: urlBaseHead, matchId: matchId))
            .serializingDecodable(MatchInfo.self)
        
        
        if let response = await dataTask.response.response {
            
            print("NetworkManager - requestMatchInfo() - Status Code: \(response.statusCode), url: \(String(describing: response.url?.debugDescription))")
            if response.statusCode == 429 {
                dataTask.resume()
            }
        } else {
            
            print("NetworkManager - requestMatchInfo() - response: nil")
        }
        
        do {
            let value = try await dataTask.value
            return value
        } catch let error {
            debugPrint(error.localizedDescription)
            throw error
        }
    }
    
    // MATCH-V4
    func requestMatchInfos(urlBaseHead: UrlHeadPoint, matchIds: [String]) async throws -> [MatchInfo] {
        let value =
        try await withThrowingTaskGroup(of: MatchInfo.self, body: { group in
            for matchId in matchIds {
                group.addTask {
                    try await self.requestMatchInfo(urlBaseHead: urlBaseHead, matchId: matchId)
                }
            }
            var result = [MatchInfo]()
            
            for try await aMatchInfo in group {
                result.append(aMatchInfo)
            }
            return result
        })
        return value.sorted { matchA, matchB in
            return matchA.info.gameStartTimestamp > matchB.info.gameStartTimestamp
        }
    }
    
    func requestUrlImage(urlString: String) throws -> UIImage {
        guard let url = URL(string: urlString) else { throw NetworkError.unvalidUrl }
        var downloadedImg = UIImage()
        let dataTask =
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let safeData = data else { return }
            guard let img = UIImage(data: safeData) else { return }
            downloadedImg = img
        }
        return downloadedImg
    }
    
    //    func requestInGameSpectator(urlBaseHead: UrlHeadPoint, encryptedSummonerId: String) async throws -> Spectator {
    //           let dataTask =
    //           ApiClient.shared.session
    //               .request(Router.inGameInfo(urlBaseHead: urlBaseHead, encryptedSummonerId: encryptedSummonerId))
    //               .serializingDecodable(Spectator.self)
    //
    //           if let response = await dataTask.response.response {
    //
    //               print("NetworkManager - requestInGameSpectator() - Status Code: \(response.statusCode), url: \(String(describing: response.url?.debugDescription))")
    //               if response.statusCode == 404 {
    //
    //                   delegate?.noIngameError()
    //
    //               }
    //
    //           } else {
    //
    //               print("NetworkManager - requestInGameSpectator() - response: nil")
    //           }
    //
    //           do {
    //               let value = try await dataTask.value
    //               return value
    //           } catch let error {
    //               debugPrint(error.localizedDescription)
    //               throw error
    //           }
    //       }
    
    
    
    // 이미지 다운로드
    func downloadImage(urlStr: String) -> UIImage? {
        guard let url = URL(string: urlStr) else {
            print("NetworkManager - URL 이미지 다운로드중 유효하지 않은 URL")
            return nil
        }
        var imgData = Data()
        let dataTask =
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let safeData = data else {
                print("NetworkManager - 이미지 데이터 없음")
                return }
            imgData = safeData
        }
        let uiImage = UIImage(data: imgData)
        return uiImage
    }
}



enum NetworkError: Error {
    case unvalidUrl, unvalidData ,unvalidImg
}

    

protocol NetworkManagerDelegate {
    func noSummonerError()
    func noIngameError()
    func isLoadingTrue()
    func isLoadingFalse()
}
