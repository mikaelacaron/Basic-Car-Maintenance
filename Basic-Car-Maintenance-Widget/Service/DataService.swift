//
//  DataService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Firebase
import FirebaseAuth

enum DataService {
    /// Fetches maintenance events for the selected vehicle from Firestore.
    /// - Parameter vehichleID: The ID of the selected vehicle.
    /// - Returns: A list of maintenance events or an error if the fetch fails.
    /// 
    /// Example usage:
    /// ```swift
    /// Task {
    ///     let result = await DataService.fetchMaintenanceEvents(for: "vehicle123")
    ///     
    ///     switch result {
    ///     case .success(let events):
    ///         print("Fetched \(events.count) maintenance events.")
    ///     case .failure(let error):
    ///         print("Failed to fetch maintenance events with error: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    static func fetchMaintenanceEvents(for vehichleID: String?) async -> Result<[MaintenanceEvent], Error> {
        guard let vehichleID else {
            return .failure(FetchError.noVehicleSelected)
        }
        
        do {
            let docRef = Firestore
                            .firestore()
                            .collection("\(FirestoreCollection.vehicles)/\(vehichleID)/\(FirestoreCollection.maintenanceEvents)")
            let snapshot = try await docRef.getDocuments()
            let events = snapshot.documents.compactMap {
                try? $0.data(as: MaintenanceEvent.self)
            }.sorted { $0.date > $1.date }
            
            return .success(events)
        } catch {
            return .failure(error)
        }
    }
    
    /// Fetches vehicles for the current user from Firestore.
    /// - Returns: A list of vehicles or an error if the fetch fails.
    /// 
    /// Example usage:
    /// ```swift
    /// Task {
    ///     let result = await DataService.fetchVehicles()
    ///     
    ///     switch result {
    ///     case .success(let vehicles):
    ///         print("Fetched \(vehicles.count) vehicles.")
    ///     case .failure(let error):
    ///         print("Failed to fetch vehicles with error: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    static func fetchVehicles() async -> Result<[Vehicle], Error> {
        guard let userID = Auth.auth().currentUser?.uid else {
            return .failure(FetchError.unauthenticated)
        }

        let docRef = Firestore
                         .firestore()
                         .collection(FirestoreCollection.vehicles)
                         .whereField(FirestoreField.userID, isEqualTo: userID)
         
        do {
            let snapshot = try await docRef.getDocuments()
            let vehicles = snapshot.documents.compactMap {
                try? $0.data(as: Vehicle.self)
            }
            return .success(vehicles)
        } catch {
            return .failure(error)
        }
    }
}

/// Errors that can occur when fetching maintenance events.
enum FetchError: LocalizedError {
    case unauthenticated
    case noVehicleSelected
    
    var errorDescription: String {
        switch self {
        case .unauthenticated:
            "You are not logged in. Please log in to continue."
        case .noVehicleSelected:
            "No vehicle selected. Please select a vehicle to continue."
        }
    }
}
