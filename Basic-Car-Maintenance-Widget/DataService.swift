//
//  DataService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseAuth
import FirebaseFirestore

enum DataService {
    /// Fetches totalmaintenance events count for the selected vehicle from Firestore.
    /// - Parameter vehicleID: The ID of the selected vehicle.
    /// - Returns: A total maintenance events count for the selected vehicle or an error if the fetch fails.
    ///  
    /// Example usage:
    /// ```swift
    /// Task {
    ///     let result = await DataService.fetchMaintenanceEventsCount(for: "vehicle123")
    ///     
    ///     switch result {
    ///     case .success(let eventsCount):
    ///         print("Total maintenance events \(eventsCount).")
    ///     case .failure(let error):
    ///         print("Failed to fetch total maintenance events count with error: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    static func fetchMaintenanceEventsCount(for vehicleID: String?) async -> Result<Int, Error> {
        guard let vehicleID else {
            return .failure(FetchError.noVehicleSelected)
        }
        
        do {
            let countRef = Firestore
                .firestore()
                .collection(FirestorePath.maintenanceEvents(vehicleID: vehicleID).path).count
            let snapshot = try await countRef.getAggregation(source: .server)
            return .success(snapshot.count.intValue)
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
    case unexpected
    var errorDescription: String? {
        switch self {
        case .unauthenticated:
            "You are not logged in. Please log in to continue."
        case .noVehicleSelected:
            "No vehicle selected. Please select a vehicle to continue."
        case .unexpected:
            "An unexpected error occurred."
        }
    }
}
