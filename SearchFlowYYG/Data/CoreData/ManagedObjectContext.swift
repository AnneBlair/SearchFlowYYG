//
//  ManagedObjectContext.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import CoreData

extension NSManagedObjectContext {

    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    public func performSaveOrRollback() {
        perform {
            _ = self.saveOrRollback()
        }
    }

    public func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}

/// 单利记录打开数据库后的 NSManagedObjectContext
class ManagedObject {
    
    var manage: NSManagedObjectContext!
    
    static let sharedManage = ManagedObject()
    
    private init() {}
}
