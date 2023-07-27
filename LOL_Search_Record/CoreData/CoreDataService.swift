//
//  CoreDataService.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/26.
//

import Foundation
import CoreData

class CoreDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "SummonerContainer"
    private let entityName: String = "Entity"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
//            self.getData()
        }
    }
    
//    private func getData() {
//        let request = NSFetchRequest<>
//    }
}
