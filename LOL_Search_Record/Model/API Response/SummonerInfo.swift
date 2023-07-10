//
//  SummonerInfo.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.

// Summoner Response

import Foundation

struct SummonerInfo: Codable {
    let id: String
    let accountId: String
    let puuid: String
    let name: String
    let profileIconId: Int
    let revisionDate: Int
    let summonerLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case id, accountId, puuid, name, profileIconId, revisionDate, summonerLevel
    }
}
