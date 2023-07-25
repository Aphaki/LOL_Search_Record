//
//  ImageUrlRouter.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/20.
// "https://ddragon.leagueoflegends.com/cdn/13.1.1/img/spell/\().png"

import Foundation

enum ImageUrlRouter {
    case champion(name: String), smallChampion(name: String), spell(name: String), item(name: String), icon(code: String)
    
    var imgUrl: String {
        switch self {
        case let .champion(name):
            return "https://ddragon.leagueoflegends.com/cdn/\(Constants.dataVersion)/img/champion/\(name).png"
            
        case let .smallChampion(name):
            return "https://ddragon.leagueoflegends.com/cdn/\(Constants.dataVersion)/img/champion/\(name).png"
        case let .spell(name):
            return "https://ddragon.leagueoflegends.com/cdn/\(Constants.dataVersion)/img/spell/\(name).png"
        case let .item(name):
            return "https://ddragon.leagueoflegends.com/cdn/\(Constants.dataVersion)/img/item/\(name).png"
        case let .icon(code):
            return "https://ddragon.leagueoflegends.com/cdn/\(Constants.dataVersion)/img/profileicon/\(code).png"
        }
    }
}
