//
//  League.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

// League Response -> return [League]
import Foundation

struct League: Codable, Identifiable {
    var id = UUID()
    
    let leagueID, queueType, tier, rank: String
    let summonerID, summonerName: String
    let leaguePoints, wins, losses: Int
    let veteran, inactive, freshBlood, hotStreak: Bool
    
    var winRates: Int {
        return wins * 100 / (wins + losses)
    }

    enum CodingKeys: String, CodingKey {
        case leagueID = "leagueId"
        case queueType, tier, rank
        case summonerID = "summonerId"
        case summonerName, leaguePoints, wins, losses, veteran, inactive, freshBlood, hotStreak
    }
}
