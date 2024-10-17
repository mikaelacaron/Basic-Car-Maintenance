//
//  OdometerViewModel.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseFirestore
import Foundation

@Observable
class OdometerViewModel {
    
    let userUID: String?
    
    var readings = [OdometerReading]()
    var showAddErrorAlert = false
    var isShowingAddOdometerReading = false
    var errorMessage: String = ""
    
    var showEditErrorAlert = false
    var selectedReading: OdometerReading?
    var isShowingEditReadingView = false
    
    var vehicles = [Vehicle]()

    init(userUID: String?) {
        self.userUID = userUID
    }
    
    func addReading(_ odometerReading: OdometerReading) throws {
        if let uid = userUID {
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
            .collection(FirestorePath.odometerReadings(vehicleID: reading.vehicleID).path)
            .document(documentId)
            .delete()
        
        if let eventIndex = readings.firstIndex(of: reading) {
            readings.remove(at: eventIndex)
        }
        
        AnalyticsService.shared.logEvent(.odometerDelete)
    }
        
    func getOdometerReadings() async {
        if let userUID = userUID {
            let db = Firestore.firestore()
            let docRef = db.collectionGroup(FirestoreCollection.odometerReadings)
                .whereField(FirestoreField.userID, isEqualTo: userUID)
            
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
    
    func updateOdometerReading(_ reading: OdometerReading) {
        
        if let userUID = userUID {
            guard let id = reading.id else { return }
            
            var readingToUpdate = reading
            readingToUpdate.userID = userUID
            
            do {
                try Firestore.firestore()
                    .collection(FirestorePath.odometerReadings(vehicleID: readingToUpdate.vehicleID).path)
                    .document(id)
                    .setData(from: readingToUpdate)
                
                AnalyticsService.shared.logEvent(.odometerUpdate)
                
                isShowingEditReadingView = false
            } catch {
                errorMessage = error.localizedDescription
                showEditErrorAlert = true
            }
        }
    }
    
    func getVehicles() async {
        if let uid = userUID {
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
