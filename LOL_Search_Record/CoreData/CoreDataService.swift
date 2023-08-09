//
//  CoreDataService.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/26.
//

import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    private let containerName: String = "SummonerContainer"
    private let entityName: String = "SummonerEntity"
    
    private(set) var entitys: [SummonerEntity] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() {  }
    
    // Create
    func addEntity(model: SummonerModel) {
        let summonerEntity = SummonerEntity(context: persistentContainer.viewContext)
        summonerEntity.iconImgId = Int16(model.iconImgId)
        summonerEntity.name = model.name
        summonerEntity.tierText = model.tierText
        summonerEntity.tierImgStr = model.tierImgStr
        summonerEntity.rank = model.rank
        saveContext()
    }
    
    // Read
    func fetchData() -> [SummonerModel] {
        let request = NSFetchRequest<SummonerEntity>(entityName: entityName)
        do {
            let fetchedCoreData = try persistentContainer.viewContext.fetch(request)
            let fetchedCoreModels = fetchedCoreData.map {
                SummonerModel(iconImgId: Int($0.iconImgId),
                              name: $0.name ?? "",
                              tierImgStr: $0.tierImgStr ?? "",
                              tierText: $0.tierText ?? "",
                              rank: $0.rank ?? "",
                              date: $0.date ?? Date())
            }
            return fetchedCoreModels
        } catch {
            print(error)
            return []
        }
    }
    
    // Update
    func upDateData(model: SummonerModel, newModel: SummonerModel) {
        let fetchRequest: NSFetchRequest<SummonerEntity> = SummonerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", model.name)
        do {
            let summonerEntitys = try context.fetch(fetchRequest)
            if let aEntity = summonerEntitys.first {
                aEntity.iconImgId = Int16(newModel.iconImgId)
                aEntity.name = newModel.name
                aEntity.tierImgStr = newModel.tierImgStr
                aEntity.tierText = newModel.tierText
                saveContext()
            }
        } catch {
            print("Error updating summonerEntity: \(error)")
        }
        
        
        saveContext()
    }
    
    // Delete
    func deleteData(model: SummonerModel) {
        let fetchRequest: NSFetchRequest<SummonerEntity> = SummonerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", model.name)
        do {
            let entitys = try context.fetch(fetchRequest)
            if let aEntity = entitys.first {
                context.delete(aEntity)
                saveContext()
            }
        } catch {
            print("Error deleting task: \(error)")
        }
        saveContext()
    }
    
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreDataService - Error saving context: \(error)")
            }
        }
    }
    
}
