//
//  FirebaseService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Firebase
import FirebaseFirestore
import Foundation

class FirebaseService: FirebaseServiceProtocol {
    
    let db = Firestore.firestore()
    
    func addReading(_ reading: OdometerReading) throws {
        try db
            .collection(FirestorePath.odometerReadings(vehicleID: reading.vehicleID).path)
            .addDocument(from: reading)
    }
    
    func deleteReading(_ reading: OdometerReading) async {
        guard let documentId = reading.id else {
            fatalError("Reading Entry has no document ID.")
        }
        try? await db
            .collection(FirestorePath.odometerReadings(vehicleID: reading.vehicleID).path)
            .document(documentId)
            .delete()
    }
    
    func getReadings(userUID: String) async -> [OdometerReading] {
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
        }
        
        return readings
    }
    
    func updateReading(_ reading: OdometerReading) throws {
        if let documentId = reading.id, let userUID = reading.userID {
            var readingToUpdate = reading
            readingToUpdate.userID = userUID
            
            try db
                .collection(FirestorePath.odometerReadings(vehicleID: readingToUpdate.vehicleID).path)
                .document(documentId)
                .setData(from: readingToUpdate)
        }
    }
    
    func getVehicles(userUID: String) async -> [Vehicle] {
        let docRef = db.collection(FirestoreCollection.vehicles)
            .whereField(FirestoreField.userID, isEqualTo: userUID)
        
        let querySnapshot = try? await docRef.getDocuments()
        
        var vehicles = [Vehicle]()
        
        if let querySnapshot {
            for document in querySnapshot.documents {
                if let vehicle = try? document.data(as: Vehicle.self) {
                    vehicles.append(vehicle)
                }
            }
        }
        
        return vehicles
    }
}
