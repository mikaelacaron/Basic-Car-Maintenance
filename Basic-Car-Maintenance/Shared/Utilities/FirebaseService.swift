//
//  FirebaseService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseFirestore

class FirebaseService: FirebaseServiceProtocol {
    func deleteMaintenanceEvent(_ event: MaintenanceEvent, withDocumentId documentId: String) async throws {
        try await Firestore
            .firestore()
            .collection(FirestorePath.maintenanceEvents(vehicleID: event.vehicleID).path)
            .document(documentId)
            .delete()
    }

    func addMaintenanceEvent(_ eventToAdd: MaintenanceEvent) throws {
        try Firestore 
            .firestore()
            .collection(FirestorePath.maintenanceEvents(vehicleID: eventToAdd.vehicleID).path)
            .addDocument(from: eventToAdd)    
    }
    
    func getEvents(withUserUID userUID: String) async throws -> [MaintenanceEvent] {
        
        let db = Firestore.firestore()
        let docRef = db.collectionGroup(FirestoreCollection.maintenanceEvents)
            .whereField(FirestoreField.userID, isEqualTo: userUID)
        
        let querySnapshot = try await docRef.getDocuments()
        
        var events = [MaintenanceEvent]()
        
        for document in querySnapshot.documents {
            if let event = try? document.data(as: MaintenanceEvent.self) {
                events.append(event)
            }
        }
        
        return events
    }
    
    func updateMaintenanceEvent(_ eventToUpdate: MaintenanceEvent, withId id: String) async throws {
        try Firestore
            .firestore()
            .collection(FirestorePath.maintenanceEvents(vehicleID: eventToUpdate.vehicleID).path)
            .document(id)
            .setData(from: eventToUpdate)
    }
}
