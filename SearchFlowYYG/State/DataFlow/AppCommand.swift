//
//  AppCommand.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import Combine
import CoreData

protocol AppCommand {
    func execute(in store: Store)
}

struct DataFlowAppCommand: AppCommand {
    
    let manage: NSManagedObjectContext
    
    func execute(in store: Store) {
        
        if FlowCoreData().getAllFlows().isEmpty {
            _ = Flow.insertArrar(context: manage)
        }
    }
}

/// 搜索事件的额外 AppCommand
struct SearchAppCommand: AppCommand {
    
    let searchValid: String
    
    func execute(in store: Store) {
        _ = DataFlowRequest(content: searchValid)
            .publisher
            .sink(receiveCompletion: { complete in
            if case .failure(let error) = complete {
                /// 解析
                print("解析错误： \(error.localizedDescription)")
            }
        }, receiveValue: { models in
            store.dispatch(.updataResultListModels(valids: models))
        })
    }
}

/// 加载更多的搜索结果所用 正式环境与上直接合并
struct LoadMoreSearchAppCommand: AppCommand{
    
    /// 页码
    let page: Int
    
    /// 每页数量
    let pageSize: Int
    
    let searchValid: String
    
    func execute(in store: Store) {
        _ = DataFlowMoreRequest(page: page, pageSize: pageSize, content: searchValid)
            .publisher
            .sink(receiveCompletion: { complete in
            if case .failure(let error) = complete {
                /// 解析
                print("解析错误： \(error.localizedDescription)")
            }
        }, receiveValue: { models in
            store.dispatch(.searchResultAppend(valids: models))
        })
    }
}
