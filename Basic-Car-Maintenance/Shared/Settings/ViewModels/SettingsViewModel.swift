//
//  SettingsViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var vehicles = [Vehicle]()
    
    func addVehicle(_ vehicle: Vehicle) async throws {
        try Firestore
            .firestore()
            .collection("vehicles")
            .addDocument(from: vehicle)
    }
    
    func getVehicles() async {
        let db = Firestore.firestore()
        let docRef = db.collection("vehicles")
        
        let querySnapshot = try? await docRef.getDocuments()
        
        if let querySnapshot {
            for document in querySnapshot.documents {
                if let event = try? document.data(as: Vehicle.self) {
                    vehicles.append(event)
                }
            }
        }
    }
    
    func deleteVehicle(_ vehicle: Vehicle) async {
        guard let documentId = vehicle.id else {
            fatalError("Event \(vehicle.name) has no document ID.")
        }
        try? await Firestore
            .firestore()
            .collection("vehicles")
            .document(documentId)
            .delete()
    }
}
