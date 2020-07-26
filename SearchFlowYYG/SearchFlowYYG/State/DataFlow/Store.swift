//
//  Store.swift
//  SearchFlowYYG
//
//  Created by AnneBlair on 2020/7/25.
//

import Foundation
import Combine
import CoreData


class Store: ObservableObject {
    
    @Published var appState = AppState()
    
    private let bag = DisposeBag()

    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.search.checker.isEffective.sink {
            isValid in
            self.dispatch(.searchTextEffective(valid: isValid))
        }.add(to: bag)
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]: \(command)")
            #endif
            command.execute(in: self)
        }
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        switch action {
        case .searchTextEffective(let valid):
            appState.search.isEffective = valid
            appCommand = SearchAppCommand(searchValid: appState.search.checker.searchValue)
        case .createDataFlowContainer(let valid):
            ManagedObject.sharedManage.manage = valid
            appCommand = DataFlowAppCommand(manage: valid)
        case .updataResultListModels(let valids):
            appState.search.models = valids
            appState.search.brandsSplits = appState.search.brandsSplit()
        case .loadMoreResultData(let valid):
            if appState.search.brandsSplits.isLastItem(valid) {
                appState.search.isLoading = true
                appCommand = LoadMoreSearchAppCommand(page: appState.search.page, pageSize: appState.search.pageSize, searchValid: appState.search.checker.searchValue)
            }
        case .searchResultAppend(let valids):
            appState.search.models.append(contentsOf: valids)
            appState.search.brandsSplits = appState.search.brandsSplit()
            appState.search.page += 1
            appState.search.isLoading = false
        }
        return (appState, appCommand)
    }
}

/// 由于 setupObservers 的 sink 会被释放掉，会导致订阅失效，可以简单的在 Sotre 里面声明一个成员变量来持有返回值 AnyCancellable
class DisposeBag {
    private var values: [AnyCancellable] = []
    
    func add(_ value: AnyCancellable) {
        synchronized(values as AnyObject) {
            values.append(value)
        }
    }
}

extension AnyCancellable {
    func add(to bag: DisposeBag) {
        bag.add(self)
    }
}

/// 线程加锁
///
/// - Parameters:
///   - lock: 加锁对象
///   - dispose: 执行闭包函数,
func synchronized(_ lock: AnyObject,dispose: ()->()) {
    objc_sync_enter(lock)
    dispose()
    objc_sync_exit(lock)
}
