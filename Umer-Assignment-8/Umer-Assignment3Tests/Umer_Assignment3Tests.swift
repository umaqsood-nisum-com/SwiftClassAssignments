//
//  Umer_Assignment3Tests.swift
//  Umer-Assignment3Tests
//
//  Created by Nisum Technologies on 05/07/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import XCTest
import CoreData
@testable import Umer_Assignment3

class Umer_Assignment3Tests: XCTestCase {


    let coreDataFetch = CoreDataFetch()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //////
    func coreDataBackgroundLoad()   {
        let backgroundDataCoordinator = BackgroundDataCoordinator()
        let backgroundDataCoordinatorExpectation = expectation(description: "BackgroundDataCoordinator loads Item in background")
        backgroundDataCoordinator.requestAndLoadEntities(objectType: "item", completionHandler: {(success) -> Void in

            XCTAssert(success)
            backgroundDataCoordinatorExpectation.fulfill()
        })
    
            waitForExpectations(timeout: 1) {
            error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testCoreDataFetchEntityById()  {
        coreDataBackgroundLoad()
        //Test happy path:
        let testId = 1
        var item:Item? = coreDataFetch.fetchEntity(byId: NSNumber.init(value: testId))
        XCTAssert(Int(item!.id) == testId)
        //Test no object path:
        item = coreDataFetch.fetchEntity(byId: NSNumber.init(value: 123))
        XCTAssertNil(item)
        // TODO: test error path:
        let entityBase:EntityBase? = coreDataFetch.fetchEntity(byId: NSNumber.init(value: 123))
        XCTAssertNil(entityBase)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
