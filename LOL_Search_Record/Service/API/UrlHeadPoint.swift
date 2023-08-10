//
//  UrlHeadPoint.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Foundation

enum UrlHeadPoint: String, CaseIterable {
    
    //br1, eun1, euw1, jp1, kr, la1, la2, na1, oc1, ru, tr1
//    case brazil, eun, euw, jp, kr, la, la2, oce, ru, tr
    
    case eun, euw, jp, kr, ru, tr
    
    var nationString: String {
        switch self {
        //브라질 - api error
//        case .brazil:
//            return "br1"
        //유럽노르딕 & 동유럽
        case .eun:
            return "eun1"
        //서유럽
        case .euw:
            return "euw1"
        //일본
        case .jp:
            return "jp1"
        //한국
        case .kr:
            return "kr"
//        //라틴 아메리카 남
//        case .la:
//            return "la1"
//        //라틴 아메리카 북
//        case .la2:
//            return "la2"
//        //오세아니아
//        case .oce:
//            return "oc1"
        //러시아
        case .ru:
            return "ru"
        //터키
        case .tr:
            return "tr1"
        
        }
    }
    
    // Americas, Asia, Europe, Sea
    var areaString: String {
        switch self {
//        case .brazil, .la, .la2:
//            return "americas"
        case .eun, .euw, .ru, .tr:
            return "europe"
        case .jp, .kr:
            return "asia"
//        case .oce:
//            return "sea"
        }
    }
    
    var urlBaseString: String {
        return "https://\(nationString).api.riotgames.com/"
    }
    var urlBaseAreaString: String {
        return "https://\(areaString).api.riotgames.com/"
    }
}
