//
//  AddVehicleViewUITest.swift
//  Basic-Car-Maintenance-UITests
//
//  Created by Andrew Muniz on 10/22/23.
//

import XCTest

class AddVehicleViewUITest: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAddVehicle() {
        // Navigate to the AddVehicleView
        app.buttons["Settings"].tap()
        app.buttons["Add Vehicle"].tap()
        
        // Fill in valid vehicle information
        let nameTextField = app.textFields["Vehicle Name"]
        nameTextField.tap()
        nameTextField.typeText("My Car")
        
        let makeTextField = app.textFields["Vehicle Make"]
        makeTextField.tap()
        makeTextField.typeText("Toyota")
        
        let modelTextField = app.textFields["Vehicle Model"]
        modelTextField.tap()
        modelTextField.typeText("Camry")
        
        // Tap the "Add" button
        app.buttons["Add"].tap()
        
    }
    
}
