//
//  Flow.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import CoreData

final class Flow: NSManagedObject {
    /// 型号
    @NSManaged public var type: String
    
    /// 类别
    @NSManaged public var category: String
    
    /// 品牌
    @NSManaged public var brand: String
    
    /// 是否有现货
    @NSManaged public var inStock: Bool
    
    /// 价格 $
    @NSManaged public var price: String
    
    /// 批量写入数据库伪数据
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: true 成功  false 失败
    static func insertArrar(context: NSManagedObjectContext) -> Bool {
        let newInfos: [[String: Any]] = [
            ["type": "V11", "category": "Vacuum", "brand": "Dyson", "inStock": true, "price": "599.99"],
            ["type": "V10", "category": "Vacuum", "brand": "Dyson", "inStock": false, "price": "399.99"],
            ["type": "Supersonic", "category": "Hair Dryer", "brand": "Dyson", "inStock": true, "price": "399.99"],
            ["type": "AMG63", "category": "Mercedes-Benz", "brand": "Benz", "inStock": true, "price": "299999.99"],
            ["type": "C63", "category": "Mercedes-Benz", "brand": "Benz", "inStock": false, "price": "299999.99"],
            ["type": "S650", "category": "Mercedes-Benz", "brand": "Benz", "inStock": true, "price": "299999.99"],
            ["type": "G500", "category": "Mercedes-Benz", "brand": "Benz", "inStock": false, "price": "299999.99"],
            ["type": "G500", "category": "Beijing-Benz", "brand": "Benz", "inStock": false, "price": "299999.99"],
            ["type": "G500", "category": "Beijing-Benz", "brand": "Benz", "inStock": true, "price": "299999.99"],
            ["type": "G500", "category": "Beijing-Benz", "brand": "Benz", "inStock": false, "price": "199999.99"]
        ]

        let insertRequest = NSBatchInsertRequest(entity: Flow.entity(), objects: newInfos)
        do {
            let insertResult = try context.execute(insertRequest)
            if let result = insertResult as? NSBatchInsertResult {
                print(result.result ?? "")
            }
            return context.saveOrRollback()
        } catch let error {
            print(error)
            return false
        }
    }
}

extension Flow: Managed {}
