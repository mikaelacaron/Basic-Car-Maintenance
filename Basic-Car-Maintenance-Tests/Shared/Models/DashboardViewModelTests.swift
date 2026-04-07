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
        let uid = UUID().uuidString
        let viewModel = DashboardViewModel(userUID: uid, firebaseService: FaillingFirebaseService())
        let event = MaintenanceEvent(
            vehicleID: "1234", 
            title: "", date: Date.now, 
            notes: ""
        )
        viewModel.addEvent(event)
        #expect(viewModel.errorMessage != "")
    }

    @Test 
    func addedEventIsRetrievedSuccessfully() async throws {
         let vehicleId = UUID().uuidString
         let eventToRetrieve = MaintenanceEvent(
            vehicleID: vehicleId, 
            title: "To fix wheels", date: Date.now, 
            notes: "Wheels must be tested after fix"
        )
        
        viewModel.addEvent(eventToRetrieve)
        try await Task.sleep(nanoseconds: 500_000_000)
        viewModel.events.removeAll()
        await viewModel.getMaintenanceEvents()
        
        #expect(viewModel.events.count == 1)
        #expect(viewModel.events.contains(where: {
            $0.title == eventToRetrieve.title && 
            $0.vehicleID == eventToRetrieve.vehicleID &&
            $0.notes == eventToRetrieve.notes &&
            $0.date == eventToRetrieve.date
        }))
    }
    
    @Test 
    func addedEventIsUpdatedSuccessfully() async {
        let vehicleId = UUID().uuidString
        let eventToAdd = MaintenanceEvent(
           vehicleID: vehicleId, 
           title: "To fix wheels", date: Date.now, 
           notes: "Wheels must be tested after fix"
       )
        
        viewModel.addEvent(eventToAdd)
        viewModel.events.removeAll()
        await viewModel.getMaintenanceEvents() // retieve events from store so we it can have an id
        guard let savedEvent = viewModel.events.first(where: {$0.vehicleID == eventToAdd.vehicleID}) else {
            return
        }
    
        let eventToUpdate = MaintenanceEvent(
            id: savedEvent.id, 
            userID: savedEvent.userID, 
            vehicleID: savedEvent.vehicleID, 
            title: "Fix the engine", date: savedEvent.date, notes: "Engine will be tested after fix")
        await viewModel.updateEvent(eventToUpdate)
        
        // get updated event
        guard let updatedEvent = viewModel.events.first(where: {$0.id == eventToUpdate.id}) else {
            return
        }
        #expect(updatedEvent.title == eventToUpdate.title)
        #expect(updatedEvent.notes == eventToUpdate.notes)
        
    }
    
    @Test 
    func errorMessageIsSetWhenEventCannotBeUpdated() async throws {
        let vehicleId = UUID().uuidString
        let eventToAdd = MaintenanceEvent(
           vehicleID: vehicleId, 
           title: "To fix wheels", date: Date.now, 
           notes: "Wheels must be tested after fix"
       )
        let viewModel = DashboardViewModel(userUID: UUID().uuidString, firebaseService: FaillingFirebaseService())
        
        viewModel.addEvent(eventToAdd)
        viewModel.events.removeAll()
        await viewModel.getMaintenanceEvents() // retieve events from store so we it can have an id
        guard let savedEvent = viewModel.events.first(where: {$0.vehicleID == eventToAdd.vehicleID}) else {
            return
        }
    
        let eventToUpdate = MaintenanceEvent(
            id: savedEvent.id, 
            userID: savedEvent.userID, 
            vehicleID: savedEvent.vehicleID, 
            title: "Fix the engine", date: savedEvent.date, notes: "Engine will be tested after fix")
        await viewModel.updateEvent(eventToUpdate)
        
        #expect(viewModel.errorMessage != "")
        
    }
    
    
    
}
