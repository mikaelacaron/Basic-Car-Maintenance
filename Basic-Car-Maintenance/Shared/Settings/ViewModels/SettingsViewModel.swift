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
final class SettingsViewModel: ObservableObject, VehiclesProtocol {
    let privacyURL = URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance-Privacy")

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
        if let uid = AppDefaults.getUserID() {
            var vehicleToAdd = vehicle
            vehicleToAdd.userID = uid
            
            do {
                try Firestore
                    .firestore()
                    .collection(FirestoreCollection.vehicles)
                    .addDocument(from: vehicleToAdd)
                vehicles = await getVehicles()
            } catch {
                throw error
            }
        }
    }
    
    /// Deletes a vehicle from both Firestore and the local ``SettingsViewModel/vehicles`` array.
    ///
    /// - Parameter vehicle: The vehicle to be deleted.
    /// - Throws: An error if there's an issue deleting the vehicle from Firestore.
    func deleteVehicle(_ vehicle: Vehicle) async throws {
        guard let documentID = vehicle.documentID,
              !documentID.isEmpty
        else {
            fatalError("Event \(vehicle.name) has no document ID.")
        }
        
        do {
            try await Firestore
                .firestore()
                .collection(FirestoreCollection.vehicles)
                .document(documentID)
                .delete()
            
            vehicles = await getVehicles()
        } catch {
            throw error
        }
    }
}
