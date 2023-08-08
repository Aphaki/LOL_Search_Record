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
    private let entityName: String = "SummonerEntity"
    
    private(set) var entitys: [SummonerEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getData()
        }
    }
    
    private func getData() {
        let request = NSFetchRequest<SummonerEntity>(entityName: entityName)
        do {
            let fetchedCoreData = try container.viewContext.fetch(request)
            self.entitys = fetchedCoreData
        } catch {
            print(error)
        }
    }
    
    func addEntity(model: summonerModel) {
        let summonerEntity = SummonerEntity(context: container.viewContext)
        summonerEntity.iconImgId = Int16(model.iconImgId)
        summonerEntity.name = model.name
        summonerEntity.tierText = model.tierText
        summonerEntity.tierImgStr = model.tierImgStr
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
    }
    
}
