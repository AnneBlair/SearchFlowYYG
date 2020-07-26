//
//  AppStateTest.swift
//  SearchFlowYYGTests
//
//  Created by AnneBlair on 2020/7/26.
//

import XCTest
import SwiftUI
import Swift

@testable import SearchFlowYYG

class AppStateTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchTextEffective() {
        let store = Store()
        store.appState.search.checker.searchValue = "Dyson"
        store.dispatch(.searchTextEffective(valid: true))
        XCTAssertTrue(store.appState.search.isEffective)
    }
    
    func testSearchUpdataResultListModels() {
        let store = Store()
        store.dispatch(.updataResultListModels(valids: [AttributeModel]()))
        XCTAssertTrue(store.appState.search.models.isEmpty)
        XCTAssertTrue(store.appState.search.brandsSplits.isEmpty)
    }
    
    func testLoadMoreResultData() {
        let store = Store()
        let valid = FlowSection(id: UUID().description, category: "Dyson", datas: [AttributeModel]())
        store.dispatch(.loadMoreResultData(valid: valid))
        XCTAssertFalse(store.appState.search.brandsSplits.isLastItem(valid))
        
        let valid1 = FlowSection(id: UUID().description, category: "Dyson", datas: [AttributeModel]())
        let valid2 = FlowSection(id: UUID().description, category: "Dyson", datas: [AttributeModel]())
        store.appState.search.brandsSplits = [valid1, valid2]
        XCTAssertTrue(store.appState.search.brandsSplits.isLastItem(valid2))
    }
    
    func testSearchResultAppend() {
        let store = Store()
        
        let model = AttributeModel(id: UUID().description, type: "Dyson", category: "Benz", brand: "Dyson", inStock: false, price: "1212")
        
        let oldCount = store.appState.search.models.count
        let oldPage = store.appState.search.page
        
        store.dispatch(.searchResultAppend(valids: [model]))
        
        let newCount = store.appState.search.models.count
        let newPage = store.appState.search.page
        
        XCTAssertTrue(oldCount != newCount)
        XCTAssertTrue(newPage != oldPage)
        XCTAssertTrue(newPage == (oldPage + 1))
        XCTAssertFalse(store.appState.search.isLoading)
    }
    
    func testSearchResult() {
        let store = Store()
        let model = AttributeModel(id: UUID().description, type: "Dyson", category: "Benz", brand: "Dyson", inStock: false, price: "1212")
        
        store.appState.search.models = [model, model, model, model, model]
        XCTAssertTrue(store.appState.search.brandsSplit().count == 1)
    }
}
