//
//  AppAction.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import CoreData

enum AppAction {
    /// 搜索字段事件
    case searchTextEffective(valid: Bool)
    /// 系统初次设置数据库数据
    case createDataFlowContainer(managedObject: NSManagedObjectContext)
    /// 更新搜索结果
    case updataResultListModels(valids: [AttributeModel])
    /// 加载更多
    case loadMoreResultData(valid: FlowSection)
    /// 追加更多数据
    case searchResultAppend(valids: [AttributeModel])
}
