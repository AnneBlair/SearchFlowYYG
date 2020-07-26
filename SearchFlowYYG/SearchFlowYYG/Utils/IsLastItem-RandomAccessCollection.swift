//
//  IsLastItem-RandomAccessCollection.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import SwiftUI

extension RandomAccessCollection where Self.Element: Identifiable {
    
    /// 判断是否是最后一个 item
    /// - Parameter item: Item
    /// - Returns: true 是 false 不是
    public func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard let itemIndex = firstIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }
        
        let distance = self.distance(from: itemIndex, to: endIndex)
        return distance == 1
    }
    
    public func isThresholdItem<Item: Identifiable>(offset: Int,
                                                    item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard let itemIndex = firstIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }
        
        let distance = self.distance(from: itemIndex, to: endIndex)
        let offset = offset < count ? offset : count - 1
        return offset == (distance - 1)
    }
}
