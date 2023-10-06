//
//  SettingsViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/11/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@Observable
final class SettingsViewModel {
    let authenticationViewModel: AuthenticationViewModel
    var contributors: [Contributor]?
    
    var vehicles = [Vehicle]()
    
    init(authenticationViewModel: AuthenticationViewModel) {
        self.authenticationViewModel = authenticationViewModel
    }
    
    let urls: [String: URL] = [
        "mikaelacaronProfile": URL(string: "https://github.com/mikaelacaron")!,
        "Basic-Car-MaintenanceRepo": URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance")!,
        "bugReport": URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues")!
    ]
    
    func getContributors() async {
        guard let url =
                URL(string: "https://api.github.com/repos/mikaelacaron/Basic-Car-Maintenance/contributors")
        else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let contributors = try decoder.decode([Contributor].self, from: data)
            self.contributors = contributors
        } catch {
            print("Error fetching or decoding contributors: \(error)")
        }
    }
    
    func addVehicle(_ vehicle: Vehicle) async {
        
        if let uid = authenticationViewModel.user?.uid {
            var vehicleToAdd = vehicle
            vehicleToAdd.userID = uid
            
            _ = try? Firestore
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
    
    func deleteVehicle(_ vehicle: Vehicle) async throws {
        guard let documentId = vehicle.id else {
            fatalError("Event \(vehicle.name) has no document ID.")
        }
        
        do {
            try await Firestore
                .firestore()
                .collection("vehicles")
                .document(documentId)
                .delete()
            
            vehicles.removeAll { $0.id == vehicle.id }
        } catch {
            throw error
        }
    }
}
