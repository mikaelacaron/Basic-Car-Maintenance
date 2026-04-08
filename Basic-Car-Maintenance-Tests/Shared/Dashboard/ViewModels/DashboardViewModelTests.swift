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
     
    init() {
        let uid =  UUID().uuidString
        userUID = uid
        viewModel = DashboardViewModel(userUID: uid)
    }
    
    
    
    @Test func maintenanceEventIsAddedSuccessfully() async throws {
        let _ = try await FirestoreTestHelper()
        let eventToAdd = MaintenanceEvent(vehicleID: UUID().uuidString, title: "Headlamp Fix", date: Date.now, notes: "")

        viewModel.addEvent(eventToAdd)
        
        #expect(viewModel.events.contains([eventToAdd]))
        #expect(viewModel.errorMessage == "")
        #expect(!viewModel.isShowingAddMaintenanceEvent)
    }
    
    @Test func errorMessageIsSetWhenEventCannotBeAddedSuccessfully() async throws {
        
        let _ = try await FirestoreTestHelper()

        let uid = UUID().uuidString
        let viewModel = DashboardViewModel(userUID: uid, firebaseService: FaillingFirebaseService())
        let event = MaintenanceEvent(
            vehicleID: UUID().uuidString, 
            title: "", date: Date.now, 
            notes: ""
        )
        
        viewModel.addEvent(event)
        
        #expect(viewModel.errorMessage != "")
        #expect(viewModel.showAddErrorAlert)
    }
    
    @Test 
    func addedEventIsRetrievedSuccessfully() async throws {
        
        let _ = try await FirestoreTestHelper()

        let vehicleId = UUID().uuidString
        let eventToAdd = MaintenanceEvent(
            vehicleID: vehicleId, 
            title: "To fix wheels", date: Date.now, 
            notes: "Wheels must be tested after fix"
        )
        
        viewModel.addEvent(eventToAdd)
        await viewModel.getMaintenanceEvents()
        
        #expect(viewModel.events.count == 1)
        #expect(viewModel.events.contains(where: {
            $0.title == eventToAdd.title && 
            $0.vehicleID == eventToAdd.vehicleID  &&
            $0.notes == eventToAdd.notes
           
        }))
    }
    
    @Test 
    func addedEventIsUpdatedSuccessfully() async throws {
        
        let _ = try await FirestoreTestHelper()

        // arrange
        let vehicleId = UUID().uuidString
        let eventToAdd = MaintenanceEvent(
            vehicleID: vehicleId, 
            title: "To fix wheels", date: Date.now, 
            notes: "Wheels must be tested after fix"
        )
        
        viewModel.addEvent(eventToAdd)
        await viewModel.getMaintenanceEvents() // retieve events from store so we it can have an id
        let savedEvent =  try #require(
            viewModel.events.first(where: {$0.vehicleID == eventToAdd.vehicleID}) 
        )
        
        let eventToUpdate = MaintenanceEvent(
            id: savedEvent.id, 
            userID: savedEvent.userID, 
            vehicleID: savedEvent.vehicleID, 
            title: "Fix the engine", date: savedEvent.date, notes: "Engine will be tested after fix")
        
        // act
        await viewModel.updateEvent(eventToUpdate)
        // get updated event
        let updatedEvent = try #require( 
            viewModel.events.first(where: {$0.id == eventToUpdate.id})
        )
        
        // assert
        #expect(updatedEvent.title == eventToUpdate.title)
        #expect(updatedEvent.notes == eventToUpdate.notes)
        
    }
    
    @Test 
    func errorMessageIsSetWhenEventCannotBeUpdated() async throws {
        
        let _ = try await FirestoreTestHelper()

        let vehicleId = UUID().uuidString
        
        let viewModel = DashboardViewModel(userUID: UUID().uuidString, firebaseService: FaillingFirebaseService())
        
        
        let eventToUpdate = MaintenanceEvent(
            id: UUID().uuidString,            
            userID: UUID().uuidString, 
            vehicleID: vehicleId, 
            title: "Fix the engine", date: Date.now, notes: "Engine will be tested after fix"
        )
        
        await viewModel.updateEvent(eventToUpdate)
        
        #expect(viewModel.errorMessage != "")
        #expect(viewModel.showAddErrorAlert)

    }
    
    @Test 
    func addedEventIsDeletedSuccessfully() async throws {
        
        let _ = try await FirestoreTestHelper()

        let vehicleId = UUID().uuidString
        let eventToAdd = MaintenanceEvent(
            vehicleID: vehicleId, 
            title: "To fix wheels", date: Date.now, 
            notes: "Wheels must be tested after fix"
        )
        
        viewModel.addEvent(eventToAdd)
        await viewModel.getMaintenanceEvents() // retieve events from store so we it can have an id
        let savedEvent = try #require( 
            viewModel.events.first(where: {$0.vehicleID == eventToAdd.vehicleID})
        )
        await viewModel.deleteEvent(savedEvent)
        
        #expect(!viewModel.events.contains(where: {$0.id == savedEvent.id}))
    }
    
    @Test 
    func errorMessageIsSetWhenEventCannotBeDeleted() async throws {
        
        let _ = try await FirestoreTestHelper()

        let vehicleId = UUID().uuidString
        let eventToDelete = MaintenanceEvent(
            id: UUID().uuidString,
            vehicleID: vehicleId, 
            title: "To fix wheels", date: Date.now, 
            notes: "Wheels must be tested after fix"
        )
        let viewModel = DashboardViewModel(userUID: UUID().uuidString, firebaseService: FaillingFirebaseService())
        
        
        await viewModel.deleteEvent(eventToDelete)
        
        #expect(viewModel.errorMessage != "")
        #expect(viewModel.showErrorAlert)

    }
    
}
