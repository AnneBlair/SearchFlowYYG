//
//  FlowCoreData.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import CoreData

/// 数据库查询
struct FlowCoreData {
    let request: NSFetchRequest<Flow>
    
    init() {
        request = Flow.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
    }
    
    /// 查询品牌的相关结果
    /// - Parameter brand: brand
    /// - Returns: [Flow] 
    func getFlowForBrand(brand: String) -> [Flow] {
        if brand.isEmpty { return [] }
        let predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@",
        #keyPath(Flow.brand), brand)
        let arr = loadPredicalToWordList(predical: predicate)
        return arr
    }
    
    /// 根据谓词获取相应的数据流[Flow]
    /// - Parameter predical: NSPredicate
    /// - Returns: [Flow]
    func loadPredicalToWordList(predical: NSPredicate) -> [Flow] {
        guard let manage = ManagedObject.sharedManage.manage else {
            return []
        }
        request.predicate = predical
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: manage, sectionNameKeyPath: nil, cacheName: nil)
        do { try frc.performFetch() } catch  { return [] }
        guard let arr = frc.fetchedObjects else { return [] }
        return arr
    }
    
    /// 获取所有的数据
    /// - Returns: [Flow]
    func getAllFlows() -> [Flow] {
        guard let manage = ManagedObject.sharedManage.manage else {
            return []
        }
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: manage, sectionNameKeyPath: nil, cacheName: nil)
        do { try frc.performFetch() } catch  { return [] }
        guard let arr = frc.fetchedObjects else { return [] }
        return arr
    }
}
