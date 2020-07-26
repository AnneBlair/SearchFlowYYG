//
//  AppState.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import CoreData
import Combine
import SwiftUI

struct AppState {
    var search = Search()
}

extension AppState {
    struct Search {
        
        /// 请求的数据、 这是未加工的，正式的后台会处理好
        var models = [AttributeModel]()
        
        /// 这个理论是后台处理好的数据，用于展示
        var brandsSplits = [FlowSection]()
        
        /// 分页加载状态判断 true 加载中
        var isLoading: Bool = false
        
        /// 当前页码
        var page: Int = 0
        
        /// 每页多少
        var pageSize: Int = 25
        
        class SearchResult {
            @Published var searchValue = ""
         
            func verifyToAnyPublisher(anyContent: Published<String>.Publisher ) -> AnyPublisher<Bool, Never> {
                let verify = anyContent
                    .debounce(for: .microseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { value -> AnyPublisher<Bool, Never> in
                        let effective = !value.isEmpty
                        return Just(effective).eraseToAnyPublisher()
                }
                return verify
                    .eraseToAnyPublisher()
            }
            
            var isEffective: AnyPublisher<Bool, Never> {
                return verifyToAnyPublisher(anyContent: $searchValue)
            }
        }
        
        func brandsSplit() -> [FlowSection] {
            let newBrands = Set(models.map { $0.category })
            return newBrands.map { category in FlowSection(category: category, datas: models.filter { $0.category == category }) }
        }
        
        var isEffective: Bool = false
        
        var isEditing: Bool = false
        
        var checker = SearchResult()
    }
}
