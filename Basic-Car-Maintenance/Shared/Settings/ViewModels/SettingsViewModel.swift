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
    
    // swiftlint:disable:next line_length
    /// Fetches the list of contributors for the GitHub repository [Basic-Car-Maintenance](https://github.com/mikaelacaron/Basic-Car-Maintenance).
    func getContributors() async {
        let url = GitHubURL.apiContributors
        
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
            
            AnalyticsService.shared.logEvent(.vehicleCreate)
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
        
        AnalyticsService.shared.logEvent(.vehicleDelete)
    }
}
