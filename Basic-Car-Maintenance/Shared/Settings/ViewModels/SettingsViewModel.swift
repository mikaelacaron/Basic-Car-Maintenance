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
    
    // swiftlint:disable:next line_length
    /// Fetches the list of contributors for the GitHub repository [Basic-Car-Maintenance](https://github.com/mikaelacaron/Basic-Car-Maintenance).
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
    
    /// Adds a new vehicle to the Firestore database and the local ``SettingsViewModel/vehicles`` array.
    ///
    /// - Parameter vehicle: The vehicle to be added.
    /// - Throws: An error if there's an issue adding the vehicle to Firestore.
    func addVehicle(_ vehicle: Vehicle) async throws {
        if let uid = authenticationViewModel.user?.uid {
            var vehicleToAdd = vehicle
            vehicleToAdd.userID = uid
            
            do {
                let firestoreRef = try Firestore
                    .firestore()
                    .collection(FirestoreCollection.vehicles)
                    .addDocument(from: vehicleToAdd)
                vehicleToAdd.id = firestoreRef.documentID
                vehicles.append(vehicleToAdd)
            } catch {
                throw error
            }
        }
    }
    
    /// Fetches the user's vehicles from Firestore based on their unique user ID.
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
    
    /// Deletes a vehicle from both Firestore and the local ``SettingsViewModel/vehicles`` array.
    ///
    /// - Parameter vehicle: The vehicle to be deleted.
    /// - Throws: An error if there's an issue deleting the vehicle from Firestore.
    func deleteVehicle(_ vehicle: Vehicle) async throws {
        guard let documentId = vehicle.id else {
            fatalError("Event \(vehicle.name) has no document ID.")
        }
        
        do {
            try await Firestore
                .firestore()
                .collection(FirestoreCollection.vehicles)
                .document(documentId)
                .delete()
            
            vehicles.removeAll { $0.id == vehicle.id }
        } catch {
            throw error
        }
    }
}
