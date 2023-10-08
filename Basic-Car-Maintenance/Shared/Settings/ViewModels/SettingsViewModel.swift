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
    
    /// Fetches the list of contributors for the GitHub repository 'Basic-Car-Maintenance'.
    ///
    /// This function makes an asynchronous network request to the GitHub API to retrieve the list of contributors for the specified repository. 
    /// It then decodes the JSON response into an array of 'Contributor' objects and updates the 'contributors' property with the result.
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
    
    /// Adds a new vehicle to the Firestore database and the local 'vehicles' array.
    ///
    /// - Parameter vehicle: The vehicle object to be added.
    /// - Throws: An error if there's an issue adding the vehicle to Firestore.
    ///
    /// This function adds a new vehicle object to the Firestore database under the 'vehicles' collection.
    func addVehicle(_ vehicle: Vehicle) async throws {
        if let uid = authenticationViewModel.user?.uid {
            var vehicleToAdd = vehicle
            vehicleToAdd.userID = uid
            
            do {
                try Firestore
                    .firestore()
                    .collection("vehicles")
                    .addDocument(from: vehicleToAdd)
            } catch {
                throw error
            }
            vehicles.append(vehicleToAdd)
        }
    }
    
    /// Fetches the user's vehicles from Firestore based on their unique user ID.
    ///
    /// This asynchronous function retrieves a list of vehicles associated with the currently authenticated user from the Firestore database.
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
    
    /// Deletes a vehicle from both Firestore and the local 'vehicles' array.
    ///
    /// - Parameter vehicle: The vehicle object to be deleted.
    /// - Throws: An error if there's an issue deleting the vehicle from Firestore.
    ///
    /// This function deletes a specific vehicle from Firestore by identifying it with its unique document ID. It also removes the vehicle from the local 'vehicles' array to keep the data in sync.
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
