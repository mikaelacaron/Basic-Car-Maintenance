//
//  OdometerViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@Observable
class OdometerViewModel {
    
    let authenticationViewModel: AuthenticationViewModel
    
    var readings = [OdometerReading]()
    var showAddErrorAlert = false
    var isShowingAddOdometerReading = false
    var errorMessage: String = ""
    var vehicles = [Vehicle]()

    init(authenticationViewModel: AuthenticationViewModel) {
        self.authenticationViewModel = authenticationViewModel
    }
    
    func addReading(_ odometerReading: OdometerReading) throws {
        if let uid = authenticationViewModel.user?.uid {
            var readingToAdd = odometerReading
            readingToAdd.userID = uid
            
            try Firestore
                .firestore()
                .collection(FirestorePath.odometerReadings(vehicleID: readingToAdd.vehicleID).path)
                .addDocument(from: readingToAdd)
            
            AnalyticsService.shared.logEvent(.odometerCreate)
        }
    }
    
    func deleteReading(_ reading: OdometerReading) async {
        guard let documentId = reading.id else {
            fatalError("Reading Entry has no document ID.")
        }
        
        try? await Firestore
            .firestore()
            .collection(FirestoreCollection.odometerReadings)
            .document(documentId)
            .delete()
        
        if let eventIndex = readings.firstIndex(of: reading) {
            readings.remove(at: eventIndex)
        }
        
        AnalyticsService.shared.logEvent(.odometerDelete)
    }
        
    func getOdometerReadings() async {
        if let uid = authenticationViewModel.user?.uid {
            let db = Firestore.firestore()
            let docRef = db.collectionGroup(FirestoreCollection.odometerReadings)
                .whereField(FirestoreField.userID, isEqualTo: uid)
            
            let querySnapshot = try? await docRef.getDocuments()
            
            var readings = [OdometerReading]()
            
            if let querySnapshot {
                for document in querySnapshot.documents {
                    if let reading = try? document.data(as: OdometerReading.self) {
                        readings.append(reading)
                    }
                }
                self.readings = readings
            }
        }
    }
    
    func getVehicles() async {
        if let uid = authenticationViewModel.user?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection(FirestoreCollection.vehicles)
                .whereField(FirestoreField.userID, isEqualTo: uid)
            
            let querySnapshot = try? await docRef.getDocuments()
            
            var vehicles = [Vehicle]()
            
            if let querySnapshot {
                for document in querySnapshot.documents {
                    if let vehicle = try? document.data(as: Vehicle.self) {
                        vehicles.append(vehicle)
                    }
                }
                
                self.vehicles = vehicles
            }
        }
    }
}
