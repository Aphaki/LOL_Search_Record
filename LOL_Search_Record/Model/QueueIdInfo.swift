//
//  QueueIdInfo.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/26.
//

import Foundation

struct QueueIDInfo: Codable {
    let queueID: Int
    let map: String
    let description, notes: String?

    enum CodingKeys: String, CodingKey {
        case queueID = "queueId"
        case map, description, notes
    }
}
