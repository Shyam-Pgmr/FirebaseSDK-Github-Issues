//
//  CoreDataManager.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private static let ModuleName = "FirebaseSDKIssues"
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: CoreDataManager.ModuleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let persistentStoreURL = self.applicationDocumentsDirectory.appendingPathComponent("\(CoreDataManager.ModuleName).sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistentStoreURL,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
        } catch {
            do {
                try FileManager.default.removeItem(at: persistentStoreURL)
            } catch {
                NSLog("Unresolved error \(error)")
            }
            fatalError("Persistent store error! \(error)")
        }
        return coordinator
    }()
    
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private func clearDeepObjectEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try privateManagedObjectContext.execute(deleteRequest)
        } catch {
            print ("There was an error - \(error)")
        }
    }
    
    fileprivate class func createFetchRequest<Entity:NSManagedObject>(entity:Entity.Type, withPredicate predicate:NSPredicate? = nil, sortBy: [NSSortDescriptor]? = nil) -> NSFetchRequest<Entity> {
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        if let predicate = predicate { fetchRequest.predicate = predicate }
        if let sortBy = sortBy { fetchRequest.sortDescriptors = sortBy }
        return fetchRequest
    }
}

// MARK: - Helper
extension CoreDataManager {
    
    class func saveContext() {
        shared.managedObjectContext.performAndWait {
            if shared.managedObjectContext.hasChanges {
                do {
                    try shared.managedObjectContext.save()
                } catch {
                    fatalError("Error saving main managed object context! \(error)")
                }
            }
        }
    }
    
    class func savePrivateContext() {
        shared.privateManagedObjectContext.performAndWait {
            if shared.privateManagedObjectContext.hasChanges {
                do {
                    try shared.privateManagedObjectContext.save()
                } catch {
                    fatalError("Error saving private managed object context! \(error)")
                }
            }
        }
    }
    
    class func delete(managedObject: NSManagedObject) {
        shared.privateManagedObjectContext.delete(managedObject)
        savePrivateContext()
    }
    
    class func deleteRecords<Entity:NSManagedObject>(entity:Entity.Type, predicate : NSPredicate? = nil) {
        guard let records = fetchRecords(entity:entity ,predicate: predicate) else { return }
        for record in records {
            delete(managedObject: record)
        }
    }
    
    class func fetchRecords<Entity:NSManagedObject>(entity:Entity.Type, predicate: NSPredicate? = nil, sortBy: [NSSortDescriptor]? = nil) -> [Entity]? {
        let fetchRequest = createFetchRequest(entity:entity ,withPredicate: predicate, sortBy: sortBy) as NSFetchRequest<Entity>
        return try? shared.privateManagedObjectContext.fetch(fetchRequest)
    }
    
    class func insertOrUpdate<Entity:NSManagedObject>(entity:Entity.Type, predicate: NSPredicate) -> Entity {
        let result = fetchRecords(entity:entity ,predicate: predicate)
        if let object = result?.first {
            return object
        } else {
            return NSEntityDescription.insertNewObject(forEntityName: String(describing: Entity.self), into: shared.privateManagedObjectContext) as! Entity
        }
    }
    
    func clearAllCoreData() {
        let entities = persistentStoreCoordinator.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }
}
