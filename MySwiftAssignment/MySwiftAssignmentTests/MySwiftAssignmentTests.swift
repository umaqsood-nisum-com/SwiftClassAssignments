//
//  MySwiftAssignmentTests.swift
//  MySwiftAssignmentTests
//
//  Created by Nisum Technologies on 18/07/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import XCTest
@testable import MySwiftAssignment

class MySwiftAssignmentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        
        let homeView = HomeViewController()
        
        let selectedTextField : setTextField = setTextField.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        selectedTextField.text = "5"
        selectedTextField.tag = 1
        let testValue : Double = 4.6
        if !(selectedTextField.text?.isEmpty)! {
            
            let txtValue = Float(selectedTextField.text!)
            homeView.testTotalValues(textField: selectedTextField)
            
            print(txtValue! - homeView.depositExpected)
            
            XCTAssert(Int(homeView.totalAmount) == Int(testValue))

            
        }

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
