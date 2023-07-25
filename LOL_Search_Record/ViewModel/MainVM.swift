//
//  MainVM.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/03.
//

import Foundation

class MainVM {
    
//    private(set) var searchedDetailInfo: DetailSummonerInfo?
    private(set) var searchedSummonersInfo: [DetailSummonerInfo] = []
    
    private(set) var urlBaseHead: UrlHeadPoint = .kr
    
    private var service = Service()
    
    
    
    func searchSummonerInfo(urlBaseHead: UrlHeadPoint, name: String) async throws -> DetailSummonerInfo {
        let searchedSummonerDetail = try await service.saveSearchedSummonerDetail(urlBase: urlBaseHead, name: name)
        return searchedSummonerDetail
    }
    
}
