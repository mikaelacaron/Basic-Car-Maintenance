//
//  MaintenanceVehicleAppEntity.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import AppIntents
import Firebase

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct MaintenanceVehicleAppEntity: AppEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Maintenance Vehicle")

    struct MaintenanceVehicleAppEntityQuery: EntityQuery {
        func entities(for identifiers: [MaintenanceVehicleAppEntity.ID]) async throws -> [MaintenanceVehicleAppEntity] {
            guard let userID = Optional("vb0owfUaNFxPHUTtGYN4jBo0fPdt") else {
             throw NSError(domain: "Unauthenticated", code: 1)
            }

            let docRef = Firestore
                         .firestore()
                         .collectionGroup(FirestoreCollection.vehicles)
                         .whereField(FirestoreField.userID, isEqualTo: userID)
             
            let snapshot = try await docRef.getDocuments()
            let vehicles = snapshot.documents.compactMap {
                try? $0.data(as: Vehicle.self)
            }
            return vehicles.map { MaintenanceVehicleAppEntity(id: $0.id ?? UUID().uuidString, displayString: $0.name) }
        }

        func suggestedEntities() async throws -> [MaintenanceVehicleAppEntity] {
            return try await entities(for: [])
        }
    }
    static var defaultQuery = MaintenanceVehicleAppEntityQuery()

    var id: String // if your identifier is not a String, conform the entity to EntityIdentifierConvertible.
    var displayString: String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayString)")
    }

    init(id: String, displayString: String) {
        self.id = id
        self.displayString = displayString
    }
}
