//
//  Umer_Assignment3UITests.swift
//  Umer-Assignment3UITests
//
//  Created by Nisum Technologies on 05/07/2017.
//  Copyright © 2017 Nisum Technologies. All rights reserved.
//

import XCTest

class Umer_Assignment3UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecording() {
        
        
        let app = XCUIApplication()
        app.buttons["Add Bin"].tap()
        
        let binAlert = app.alerts["Bin"]
        binAlert.collectionViews.textFields["Bin name"].typeText("New Bin")
        binAlert.buttons["OK"].tap()
        
        let addItemNameTextField = app.textFields["Add Item Name"]
        addItemNameTextField.tap()
        app.buttons["Add Location"].tap()
        
        let locationAlert = app.alerts["Location"]
        let locationNameTextField = locationAlert.collectionViews.textFields["Location name"]
        locationNameTextField.typeText("")
        locationNameTextField.typeText("New Location")
        locationAlert.buttons["OK"].tap()
        addItemNameTextField.tap()
        
    }
    func testExample() {
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

}
