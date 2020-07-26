//
//  ContentView.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import SwiftUI

/// 搜索视图
struct ContentView: View {
    
    @EnvironmentObject var store: Store
    
    var searchBinding: Binding<AppState.Search> {
        $store.appState.search
    }
    
    var search: AppState.Search {
        store.appState.search
    }
    
    var body: some View {
        VStack () {
            VStack(alignment: .leading, spacing: 3) {
                if !search.isEditing {
                    Text("Search")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                }
                SearchBar(text: searchBinding.checker.searchValue, isEditing: searchBinding.isEditing)
                    .padding(.top, 5)
                    .animation(.default)
            }.padding(.all, 15)
            resultView
        }.background(Color(#colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)).edgesIgnoringSafeArea(.all)).padding(.top, 0)
    }
    
    var resultView: some View {
        ScrollView() {
            if search.models.isEmpty && !search.checker.searchValue.isEmpty {
                Text("No result")
                    .foregroundColor(.gray)
                    .fontWeight(.semibold).padding(.top, 40)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(search.brandsSplits) { flowSection in
                        Text(flowSection.category)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                            .padding(.all, 15)
                            .multilineTextAlignment(.leading)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        ForEach(flowSection.datas) { model in
                            FlowRow(model: model)
                            if !flowSection.datas.isLastItem(model) {
                                Divider()
                            }
                        }.onAppear {
                            /// 这是分页加载更多 Action
                            store.dispatch(.loadMoreResultData(valid: flowSection))
                        }
                    }
                }
            }
        }.background(Color(#colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)).edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ListSeparatorStyle: ViewModifier {
    
    let style: UITableViewCell.SeparatorStyle
    
    func body(content: Content) -> some View {
        content
            .onAppear() {
                UITableView.appearance().separatorStyle = self.style
            }
    }
}
 
extension View {
    
    func listSeparatorStyle(style: UITableViewCell.SeparatorStyle) -> some View {
        ModifiedContent(content: self, modifier: ListSeparatorStyle(style: style))
    }
}
