//
//  MoodyStack.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import CoreData

/// 首次启动APP打开数据库
/// - Parameter completion: 使用闭包回调传递打开结果
/// - Returns: 闭包
func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    let container = NSPersistentCloudKitContainer(name: "FlowData")
    container.loadPersistentStores { (_, error) in
        guard error == nil else { fatalError("failed to load store: \(String(describing: error))")}
        DispatchQueue.main.async {
            completion(container)
        }
    }
}
