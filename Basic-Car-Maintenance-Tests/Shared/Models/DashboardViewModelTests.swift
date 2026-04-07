//
//  DashboardViewModelTests.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Testing
@testable import Basic_Car_Maintenance
import Foundation
import FirebaseFirestore
import Firebase

struct DashboardViewModelTests {
    
    var userUID: String 
    var viewModel: DashboardViewModel
    var event: MaintenanceEvent
    
    init() {
        let uid =  UUID().uuidString
        userUID = uid
        viewModel = DashboardViewModel(userUID: uid)
        event = MaintenanceEvent(userID: uid, vehicleID: "1234", title: "Headlamp Fix", date: Date.now, notes: "")
    }
    
 

    @Test func maintenanceEventIsAddedSuccessfully() async throws {
        viewModel.addEvent(event)
        #expect(viewModel.events.contains([event]))
        #expect(viewModel.errorMessage == "")
        #expect(!viewModel.isShowingAddMaintenanceEvent)
    }
    
    @Test func errorMessageIsSetWhenEventCannotBeAddedSuccessfully() async throws {
        let viewModelWithNoUID = DashboardViewModel(userUID: nil)
        let eventWithNoVehicleId = MaintenanceEvent(
            userID: "", 
            vehicleID: "1234", 
            title: "", date: Date.now, 
            notes: ""
        )
        viewModelWithNoUID.addEvent(eventWithNoVehicleId)
        #expect(viewModelWithNoUID.errorMessage != "")
    }

    
}
