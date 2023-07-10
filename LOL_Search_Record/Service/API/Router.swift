//
//  Router.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/10.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
case summoner(urlBaseHead: UrlHeadPoint, name: String)
case league(urlBaseHead: UrlHeadPoint, encryptedSummonerId: String)
case match(urlBaseHead: UrlHeadPoint, puuid: String, start: Int = 0 , count: Int = 20)
case matchInfo(urlBaseHead:UrlHeadPoint, matchId: String)
case inGameInfo(urlBaseHead: UrlHeadPoint, encryptedSummonerId: String)
    
    var baseURL: URL {
            switch self {
            case let .summoner(urlBaseHead, _):
                return URL(string: urlBaseHead.urlBaseString)!
            case let .league(urlBaseHead, _):
                return URL(string: urlBaseHead.urlBaseString)!
            case let .match(urlBaseHead, _, _, _):
                return URL(string: urlBaseHead.urlBaseAreaString)!
            case let .matchInfo(urlBaseHead, _):
                return URL(string: urlBaseHead.urlBaseAreaString)!
            case let .inGameInfo(urlBaseHead, _):
                return URL(string: urlBaseHead.urlBaseString)!
            }
        }
    
    var path: String {
            switch self {
            case let .summoner(_, name):
                return "lol/summoner/v4/summoners/by-name/\(name)"
            case let .league(_, encryptedSummonerId):
                return "lol/league/v4/entries/by-summoner/\(encryptedSummonerId)"
            case let .match(_, puuid, _, _):
                return "lol/match/v5/matches/by-puuid/\(puuid)/ids"
            case let .matchInfo(_, matchID):
                return "lol/match/v5/matches/\(matchID)"
            case let .inGameInfo(_, encryptedSummonerId):
                return "lol/spectator/v4/active-games/by-summoner/\(encryptedSummonerId)"
            }
        }
    
    var method: HTTPMethod {
            return .get
        }
    
    var parameter: [String:Int] {
            switch self {
            case let .match(_, _, start, count):
                return ["start" : start , "count" : count]
            default:
                return [:]
            }
        }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appending(path: path)
        
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameter, into: request)
        
        return request
    }
}
