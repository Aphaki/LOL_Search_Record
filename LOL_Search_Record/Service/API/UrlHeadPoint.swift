//
//  UrlHeadPoint.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Foundation

enum UrlHeadPoint {
    
    //br1, eun1, euw1, jp1, kr, la1, la2, na1, oc1, ru, tr1
    case brOne, eunOne, euwOne, jpOne, kr, laOne, laTwo, ocOne, ru, tr1
    
    var nationString: String {
        switch self {
        //브라질
        case .brOne:
            return "br1"
        //유럽노르딕 & 동유럽
        case .eunOne:
            return "eun1"
        //서유럽
        case .euwOne:
            return "euw1"
        //일본
        case .jpOne:
            return "jp1"
        //한국
        case .kr:
            return "kr"
        //라틴 아메리카 남
        case .laOne:
            return "la1"
        //라틴 아메리카 북
        case .laTwo:
            return "la2"
        //오세아니아
        case .ocOne:
            return "oc1"
        //러시아
        case .ru:
            return "ru"
        //터키
        case .tr1:
            return "tr1"
        
        }
    }
    
    // Americas, Asia, Europe, Sea
    var areaString: String {
        switch self {
        case .brOne, .laOne, .laTwo:
            return "americas"
        case .eunOne, .euwOne, .ru, .tr1:
            return "europe"
        case .jpOne, .kr:
            return "asia"
        case .ocOne:
            return "sea"
        }
    }
    
    var urlBaseString: String {
        return "https://\(nationString).api.riotgames.com/"
    }
    var urlBaseAreaString: String {
        return "https://\(areaString).api.riotgames.com/"
    }
}
