//
//  JsonManager.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/25.
//

import Foundation

class JsonManager {
    static let shared = JsonManager()
    
    func readJsonFile<T: Codable>(filename: String, as type: T.Type) -> T? {
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("\(filename).json not found")
        }
        let decoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: fileUrl)
            do {
                let queueIdInfo = try decoder.decode(T.self, from: jsonData)
                return queueIdInfo
            } catch  {
                print("\(filename) jsonData Decode Error")
            }
        } catch {
            print("\(filename) fileUrl not found")
        }
        
        return nil
    }
}
