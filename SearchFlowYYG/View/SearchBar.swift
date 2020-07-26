//
//  SearchBar.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/24.
//

import SwiftUI

/// 自定义手势视图
struct SearchBar: View {
    
    @Binding var text: String

    @Binding var isEditing: Bool
    
    var body: some View {
        TextField("Top here to search", text: $text)
            .padding(.all, 10)
            .padding(.horizontal, isEditing ? 0 : 20)
            .background(Color(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)))
            .cornerRadius(8)
            .overlay(
                HStack {
                    if !isEditing {
                        searchBarLeftImage
                    }
                    Spacer()
                    if isEditing {
                        searchCancel
                            .animation(.default)
                            .padding(.trailing, 10)
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
            ).onTapGesture {
                self.isEditing = true
            }
    }
    
    var searchCancel: some View {
        Button(action: {
            self.isEditing = false
            self.text = ""
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
        }) {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
        }
    }
    
    var searchBarLeftImage: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), isEditing: .constant(false))
    }
}
