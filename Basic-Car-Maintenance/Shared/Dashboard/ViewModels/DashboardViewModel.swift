//
//  DashboardViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/3/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    
    @Published var events = [MaintenanceEvent]()
    
    func addEvent(_ maintenanceEvent: MaintenanceEvent) async throws {
        try Firestore
            .firestore()
            .collection("maintenance_events")
            .addDocument(from: maintenanceEvent)
    }
    
    func getMaintenanceEvents() async {
        let db = Firestore.firestore()
        let docRef = db.collection("maintenance_events")
        
        let querySnapshot = try? await docRef.getDocuments()
        
        if let querySnapshot {
            for document in querySnapshot.documents {
                if let event = try? document.data(as: MaintenanceEvent.self) {
                    events.append(event)
                }
            }
        }
    }
    
    func deleteEvent(_ event: MaintenanceEvent) async {
        guard let documentId = event.id else {
            fatalError("Event \(event.title) has no document ID.")
        }
        try? await Firestore
            .firestore()
            .collection("maintenance_events")
            .document(documentId)
            .delete()
    }
}
