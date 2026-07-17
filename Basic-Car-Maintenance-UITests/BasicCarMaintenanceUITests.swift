//
//  Basic_Car_Maintenance-UITests.swift
//  Basic-Car-Maintenance-UITests
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import XCTest

final class BasicCarMaintenanceUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAddVehicle() {
        // Navigate to the AddVehicleView
        app.buttons["Settings"].tap()
        app.collectionViews.buttons["Add Vehicle"].tap()
        
        let nameTextField = app.textFields["Vehicle Name"]
        nameTextField.tap()
        nameTextField.typeText("My Car")
        
        let makeTextField = app.textFields["Vehicle Make"]
        makeTextField.tap()
        makeTextField.typeText("Toyota")
        
        let modelTextField = app.textFields["Vehicle Model"]
        modelTextField.tap()
        modelTextField.typeText("Camry")
        
        app.buttons["Add"].tap()
    }
    
}
