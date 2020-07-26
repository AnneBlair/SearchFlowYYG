//
//  FlowRow.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//  243 247 253

import SwiftUI

/// 结果 Cell 的视图
struct FlowRow: View {
    
    let model: AttributeModel
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading){
                Text(model.type)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(model.inStock ? "In-stock" : "Out-of-stock")
                    .font(.footnote)
            }
            Spacer()
            Text("$\(model.price)")
                .frame(height: 30)
                .foregroundColor(model.inStock ? Color.blue : Color.gray)
                .padding([.leading, .trailing], 15)
                .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(model.inStock ? Color(#colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9921568627, alpha: 1)) : Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)))
                    .cornerRadius(10)
                )
        }
        .frame(height: 60)
        .padding([.leading, .trailing], 15)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct FlowRow_Previews: PreviewProvider {
    static var previews: some View {
        FlowRow(model: AttributeModel(id: "123", type: "", category: "", brand: "", inStock: true, price: "399"))
    }
}
