//
//  FirebaseServices.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseFirestore
import Foundation

class FirebaseService {
    private init() { }
    
    static let shared = FirebaseService()
    
    func addReading(_ reading: OdometerReading) throws {
        try Firestore
            .firestore()
            .collection(FirestorePath.odometerReadings(vehicleID: reading.vehicleID).path)
            .addDocument(from: reading)
    }
    
    func deleteReading(reading: OdometerReading, documentId: String) async {
        try? await Firestore
            .firestore()
            .collection(FirestorePath.odometerReadings(vehicleID: reading.vehicleID).path)
            .document(documentId)
            .delete()
    }
    
    func getReadings(userUID: String) async -> [OdometerReading] {
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
        }
        
        return readings
    }
    
    func updateReading(reading: OdometerReading, documentId: String, userUID: String) throws {
        var readingToUpdate = reading
        readingToUpdate.userID = userUID
        
        try Firestore.firestore()
            .collection(FirestorePath.odometerReadings(vehicleID: readingToUpdate.vehicleID).path)
            .document(documentId)
            .setData(from: readingToUpdate)
    }
    
    func getVehicles(uid: String) async -> [Vehicle] {
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
        }
        
        return vehicles
    }
}
