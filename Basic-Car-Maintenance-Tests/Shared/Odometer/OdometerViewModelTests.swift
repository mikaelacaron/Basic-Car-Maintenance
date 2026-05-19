//
//  OdometerViewModelTests.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Testing
@testable import Basic_Car_Maintenance

@Suite(.disabled("Requires Firebase emulator running. Re-enable once CI is configured to run the emulator."))
class OdometerViewModelTests {
    let userUID: String
    let viewModel: OdometerViewModel
    let newReading: OdometerReading
    var dbReading: OdometerReading?
    
    init() {
        UserDefaults.standard.set(true, forKey: "useEmulator")
        
        self.userUID = UUID().uuidString
        self.viewModel = OdometerViewModel(userUID: userUID, firebaseService: FirebaseService())
        self.newReading = OdometerReading(userID: userUID, 
                                          date: Date.now,
                                          distance: 138542,
                                          isMetric: true, 
                                          vehicleID: "LV0000")
    }
    
    // helper functions
    private func dbContainsReading(reading: OdometerReading) async -> Bool {
        let docRef = Firestore.firestore().collectionGroup(FirestoreCollection.odometerReadings)
            .whereField(FirestoreField.userID, isEqualTo: userUID)
        
        let querySnapshot = try? await docRef.getDocuments()
        
        if let querySnapshot {
            for document in querySnapshot.documents {
                if let reading = try? document.data(as: OdometerReading.self) {
                    dbReading = reading
                    return dbReading?.userID == newReading.userID &&
                    dbReading?.vehicleID == newReading.vehicleID &&
                    dbReading?.distance == newReading.distance
                }
            }
        }
        
        return false
    }
    
    // tests
    @Test func viewModelInitialState() throws {
        #expect(viewModel.userUID == userUID)
        #expect(viewModel.readings.isEmpty)
        #expect(viewModel.vehicles.isEmpty)
        #expect(viewModel.errorMessage.isEmpty)
        #expect(viewModel.showAddErrorAlert == false)
        #expect(viewModel.isShowingAddOdometerReading == false)
        #expect(viewModel.showEditErrorAlert == false)
        #expect(viewModel.isShowingEditReadingView == false)
    }

    @Test func addReading() async {
        try? viewModel.addReading(newReading);
        let dbContainsNewReading = await dbContainsReading(reading: newReading)
            
        #expect(dbContainsNewReading == true, "New reading should be added to database")
    }
    
    @Test func deleteReading() async {
        try? viewModel.addReading(newReading);
        let dbContainsNewReading = await dbContainsReading(reading: newReading)
        
        if dbContainsNewReading, let dbReading {
            await viewModel.firebaseService.deleteReading(dbReading);
            let dbContainsDeletedReading = await dbContainsReading(reading: newReading)
            
            #expect(dbContainsDeletedReading == false, "New reading should be removed from database")
        }
    }
    
    @Test func updateOdometerReading() async {
        try? viewModel.addReading(newReading);
        let dbContainsNewReading = await dbContainsReading(reading: newReading)
        
        if let dbReading {
            let updatedReading = OdometerReading(id: dbReading.id,
                                             userID: userUID, 
                                             date: Date.now,
                                             distance: 138542,
                                             isMetric: true, 
                                             vehicleID: "LV0000")
            
            viewModel.updateOdometerReading(updatedReading)
            let dbContainsUpdatedReading = await dbContainsReading(reading: updatedReading);
            
            #expect(dbContainsUpdatedReading == true, "Database reading should reflect updates")
        }
    }
    
    @Test func getReadings() async {
        await viewModel.getOdometerReadings()
        
        let dbReadings = await viewModel.firebaseService.getReadings(userUID: userUID)
        
        #expect(viewModel.readings == dbReadings, "View model vehicles should match database readings")
    }
    
    @Test func getVehicles() async {
        await viewModel.getVehicles()
        
        let dbVehicles = await viewModel.firebaseService.getVehicles(userUID: userUID)
        
        #expect(viewModel.vehicles == dbVehicles, "View model vehicles should match database readings")
    }
}
