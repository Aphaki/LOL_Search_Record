//
//  String.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/14.
//

import Foundation

extension String {
    func toProfileiconUrl() -> String {
        return "https://ddragon.leagueoflegends.com/cdn/\(Constants.dataVersion)/img/profileicon/\(self).png"
    }
    
    func toChampionSmallImgUrl() -> String {
        return "https://ddragon.leagueoflegends.com/cdn/\(Constants.dataVersion)/img/champion/\(self).png"
    }
}
