//
//  CoreDataTest.swift
//  SearchFlowYYGTests
//
//  Created by AnneBlair on 2020/7/26.
//

import XCTest
import CoreData
@testable import SearchFlowYYG

class CoreDataTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCoreData() {
        XCTAssertTrue(nil != ManagedObject.sharedManage.manage)
        XCTAssertFalse(nil == ManagedObject.sharedManage.manage)
        
        guard let manage = ManagedObject.sharedManage.manage else { return  }
         
        let store = Store()
        store.dispatch(.createDataFlowContainer(managedObject: manage))
        XCTAssertTrue(manage == ManagedObject.sharedManage.manage)
    }
    
    func testFlowCoreData() {
        let flow = FlowCoreData()
        XCTAssertTrue(20 == flow.request.fetchBatchSize)
        XCTAssertTrue(false == flow.request.returnsObjectsAsFaults)
        XCTAssertTrue(flow.getFlowForBrand(brand: "").isEmpty)
    }
}
