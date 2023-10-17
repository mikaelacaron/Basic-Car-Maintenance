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
    
    var sortedContributors: [Contributor] {
        guard let contributors = contributors, !contributors.isEmpty else {
            return []
        }
        
        return contributors.sorted { (contributor1, contributor2) in
            switch (contributor1.contributions, contributor2.contributions) {
            case let (contributor1, contributor2) where contributor1 > contributor2:
                return true
            case let (contributor1, contributor2) where contributor1 < contributor2:
                return false
            default:
                return contributor1.login < contributor2.login
            }
        }
    }
    
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
                try Firestore
                    .firestore()
                    .collection(FirestoreCollection.vehicles)
                    .addDocument(from: vehicleToAdd)
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
    /// it also deletes all associated maintenance events for this vehicle
    ///
    /// - Parameter vehicle: The vehicle to be deleted.
    /// - Throws: An error if there's an issue deleting the vehicle from Firestore.
    func deleteVehicle(_ vehicle: Vehicle) async throws {
        guard let documentId = vehicle.id else {
            fatalError("Event \(vehicle.name) has no document ID.")
        }
        
        do {
            let vehicleRef = Firestore
                .firestore()
                .collection(FirestoreCollection.vehicles)
                .document(documentId)

            if let vehicle = try? await vehicleRef.getDocument().data(as: Vehicle.self),
               let uid = authenticationViewModel.user?.uid {
                // Get all events with the associated user ide
                let events = try await Firestore
                    .firestore()
                    .collection(FirestoreCollection.maintenanceEvents)
                    .whereField(FirestoreField.userID, isEqualTo: uid)
                    .getDocuments()

                for event in events.documents {
                    // Now check if the document is a valid MaintenanceEvent and if it has the same
                    // vehicle like the vehicle we want to delete.
                    // Because the vehicle and the vehicle in the event has different ids,
                    // we have to check the hash value which is constructed without the id
                    if let maintenanceEvent = try? event.data(as: MaintenanceEvent.self),
                       maintenanceEvent.vehicle.hashValue == vehicle.hashValue {
                        try await event.reference.delete()
                    }
                }

                // After all events are deleted we can now safely delete the vehicle
                try await vehicleRef.delete()
                vehicles.removeAll { $0.hashValue == vehicle.hashValue }
            }
        } catch {
            throw error
        }
    }
}
