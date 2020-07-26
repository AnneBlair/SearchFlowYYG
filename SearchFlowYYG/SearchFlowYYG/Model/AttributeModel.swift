//
//  AttributeModel.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/24.
//

import SwiftUI

/// 基础模型属性
struct AttributeModel: Identifiable, Codable {
    
    let id: String
    
    /// 型号
    let type: String
    
    /// 类别
    let category: String
    
    /// 品牌
    let brand: String
    
    /// 是否有现货
    let inStock: Bool
    
    /// 价格 $
    let price: String
    
    init(id: String, type: String, category: String, brand: String, inStock: Bool, price: String) {
        self.id = id
        self.type = type
        self.category = category
        self.brand = brand
        self.inStock = inStock
        self.price = price
    }
}

/// 搜索结果模型 这个是最终后台应该返回的基础样子
struct FlowSection: Identifiable, Codable {
    
    var id: String = UUID().description
    
    let category: String
    
    let datas: [AttributeModel]
}
