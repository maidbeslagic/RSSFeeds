//
//  NSManagedObjectContext+Extensions.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 9. 12. 2021..
//

import CoreData

extension NSManagedObjectContext {
    func insertObject<T: NSManagedObject>() -> T where T: Managed {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else { fatalError("Wrong object type") }
        return object
    }
    
    @discardableResult
    func saveOrRollback() -> Bool {
        do {
            if hasChanges { try save() }
            return true
        } catch let error {
            rollback()
            logger.log("saveOrRollback error: \(String(describing: error.localizedDescription))", type: .error)
            return false
        }
    }
}
