//
//  OdometerViewModelTests.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import Testing
@testable import Basic_Car_Maintenance

struct OdometerViewModelTests {

    @Test func viewModelInitialState() throws {
        let userUID = "testUser1"
        let viewModel = OdometerViewModel(userUID: userUID, firebaseService: MockFirebaseService())
        
        #expect(viewModel.userUID == userUID)
        #expect(viewModel.readings.isEmpty)
        #expect(viewModel.vehicles.isEmpty)
        #expect(viewModel.errorMessage.isEmpty)
        #expect(viewModel.showAddErrorAlert == false)
        #expect(viewModel.isShowingAddOdometerReading == false)
        #expect(viewModel.showEditErrorAlert == false)
        #expect(viewModel.isShowingEditReadingView == false)
    }

    @Test func addReading() {
        let userUID = "testUser1"
        let firebaseService = MockFirebaseService()
        let viewModel = OdometerViewModel(userUID: userUID, firebaseService: firebaseService)
        let newReading = OdometerReading(id: "reading3", 
                                         userID: "testUser1", 
                                         date: Date.now, 
                                         distance: 138542, 
                                         isMetric: true, 
                                         vehicleID: "LV0000")
        
        try? viewModel.addReading(newReading)
        
        #expect(firebaseService.readings.contains(newReading) == true, "New reading should be added to database")
    }
    
    @Test func deleteReading() async {
        let userUID = "testUser1"
        let firebaseService = MockFirebaseService()
        let viewModel = OdometerViewModel(userUID: userUID, firebaseService: firebaseService)
        let reading = OdometerReading(id: "reading3", 
                                      userID: "testUser1", 
                                      date: Date.now, 
                                      distance: 138542, 
                                      isMetric: true, 
                                      vehicleID: "LV0000")
        guard let documentId = reading.id else { return }
        
        await viewModel.firebaseService.deleteReading(reading: reading, documentId: documentId)
        
        #expect(firebaseService.readings.contains(reading) == false, "Reading should be removed from database")
    }

    @Test func getOdometerReadings() async {
        let userUID = "testUser1"
        let firebaseService = MockFirebaseService()
        let viewModel = OdometerViewModel(userUID: userUID, firebaseService: firebaseService)
        
        await viewModel.getOdometerReadings()
        
        #expect(viewModel.readings == firebaseService.readings.filter({ $0.userID == userUID }), "View model readings should match database readings for specified user")
    }
    
    @Test func updateOdometerReading() {
        let userUID = "testUser1"
        let firebaseService = MockFirebaseService()
        let viewModel = OdometerViewModel(userUID: userUID, firebaseService: firebaseService)
        let updatedReading = OdometerReading(id: "reading3", 
                                             userID: "testUser1", 
                                             date: Date.now, 
                                             distance: 138543, 
                                             isMetric: true, 
                                             vehicleID: "LV0000")
        guard let index = firebaseService.readings.firstIndex(where: { $0.id == updatedReading.id }) else { return }
        
        firebaseService.readings[index] = updatedReading
        viewModel.updateOdometerReading(updatedReading)
        
        #expect(firebaseService.readings[index] == updatedReading, "Database reading should reflect updates")
    }
    
    @Test func getVehicles() async {
        let userUID = "testUser1"
        let firebaseService = MockFirebaseService()
        let viewModel = OdometerViewModel(userUID: userUID, firebaseService: firebaseService)
        
        await viewModel.getVehicles()
        
        #expect(viewModel.vehicles == firebaseService.vehicles, "View model vehicles should match database readings")
    }
}
