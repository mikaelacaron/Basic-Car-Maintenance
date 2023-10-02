//
//  SettingsViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

@Observable
final class SettingsViewModel {
    let authenticationViewModel: AuthenticationViewModel
    
    var vehicles = [Vehicle]()
    
    init(authenticationViewModel: AuthenticationViewModel) {
        self.authenticationViewModel = authenticationViewModel
    }
    
    func addVehicle(_ vehicle: Vehicle) async {
        
        if let uid = authenticationViewModel.user?.uid {
            var vehicleToAdd = vehicle
            vehicleToAdd.userID = uid
            
            try? Firestore
                .firestore()
                .collection("vehicles")
                .addDocument(from: vehicleToAdd)

            vehicles.append(vehicleToAdd)
        }
    }
    
    func getVehicles() async {
        if let uid = authenticationViewModel.user?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection("vehicles").whereField("userID", isEqualTo: uid)
            
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
