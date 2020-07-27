//
//  DataFlowRequest.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import Foundation
import Combine

/// 模拟网络请求，使用 Combine 框架, 详情可以查看 Combine 框架解析
struct DataFlowRequest {
    
    /// 查询的关键词
    let content: String
    
    var publisher: AnyPublisher<[AttributeModel], AppError> {
        Future { promise in
            /// 伪代码
            /// 访问数据库
            let flows = FlowCoreData().getFlowForBrand(brand: self.content)
            let models = flows.map { AttributeModel(id: UUID().description, type: $0.type, category: $0.category, brand: $0.brand, inStock: $0.inStock, price: $0.price) }
            promise(.success(models))
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
