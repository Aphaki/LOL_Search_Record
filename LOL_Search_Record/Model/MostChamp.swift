//
//  MostChamp.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/20.
//

import Foundation

struct MostChamp: Identifiable {
    let id = UUID()
    let championName: String
    let winningRate: Int
    let kda: Double
}
