//
//  DataFlowMoreRequest.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import Foundation
import Combine

/// 模拟网络请求加载更多数据，使用 Combine 框架, 详情可以查看 Combine 框架解析
struct DataFlowMoreRequest {
    
    /// 页码 (伪请求，未用)
    let page: Int
    
    /// 每页数量  (伪请求，未用)
    let pageSize: Int
    
    /// 查询的关键词
    let content: String
    
    var publisher: AnyPublisher<[AttributeModel], AppError> {
        Future { promise in
            /// 伪代码
            /// 访问数据库
            let flows = FlowCoreData().getFlowForBrand(brand: content)
            let models = flows.map { AttributeModel(id: UUID().description, type: $0.type, category: $0.category, brand: $0.brand, inStock: $0.inStock, price: $0.price) }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                promise(.success(models))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
