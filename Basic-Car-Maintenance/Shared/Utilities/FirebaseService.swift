//
//  FirebaseService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseFirestore

class FirebaseService: FirebaseServiceProtocol {
    
    func addMaintenanceEvent(_ eventToAdd: MaintenanceEvent) throws {
        try Firestore
            .firestore()
            .collection(FirestorePath.maintenanceEvents(vehicleID: eventToAdd.vehicleID).path)
            .addDocument(from: eventToAdd)    
    }
}
