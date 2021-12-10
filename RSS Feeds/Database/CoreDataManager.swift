//
//  CoreDataManager.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 6. 12. 2021..
//

import CoreData

final class CoreDataManager {
    private let databaseName = "RSSFeeds"
    static let shared = CoreDataManager()
    
    //MARK: Private Init
    private init() { }
    
    // MARK: Core Data Stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: databaseName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let nserror = error as NSError? {
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        })
        return container
    }()
    
    var mainMOC: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundMOC: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
