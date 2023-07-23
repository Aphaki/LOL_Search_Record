//
//  DictionaryStore.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/21.
//

import Foundation

class DictionaryStore {
    static let shared = DictionaryStore()
    
    var spellStore: [String:String] {
        guard let fileUrl = Bundle.main.url(forResource: "summoner", withExtension: "json") else {
            fatalError("summoner.json not found")
        }
        let decoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: fileUrl)
            do {
                let spellDetail = try decoder.decode(SummonerSpells.self, from: jsonData)
                let data = spellDetail.data.map { (_, value) in

                    return value
                }
                var dic = [String:String]()
                for spell in data {
                    dic[spell.key] = spell.id
                }
                return dic
            } catch {
                print("SummonerSpell jsonData Decode Error")
            }
            
        } catch {
            print("SummonerSpell fileUrl not found")
        }
        
        return [:]
    }
    
    
}
// summoner JSON "https://ddragon.leagueoflegends.com/cdn/13.14.1/data/ko_KR/summoner.json"
// 아이템 세부 "https://ddragon.leagueoflegends.com/cdn/13.14.1/data/ko_KR/item.json"
