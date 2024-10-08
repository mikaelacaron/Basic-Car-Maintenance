//
//  VehicleAppEntity.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import AppIntents
import Firebase

struct VehicleAppEntity: AppEntity {
    var id: String 
    var displayString: String
    var data: Vehicle
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayString)")
    }
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Maintenance Vehicle")
    static var defaultQuery = VehicleAppEntityQuery()

    init(id: String, displayString: String, data: Vehicle) {
        self.id = id
        self.displayString = displayString
        self.data = data
    }
}

struct VehicleAppEntityQuery: EntityQuery {
    func entities(
        for identifiers: [VehicleAppEntity.ID]
    ) async throws -> [VehicleAppEntity] {
        guard let userID = Optional("vb0owfUaNFxPHUTtGYN4jBo0fPdt") else {
            return []
        }

        // Retrieve all vehicles for a given user id.
        let docRef = Firestore
                         .firestore()
                         .collectionGroup(FirestoreCollection.vehicles)
                         .whereField(FirestoreField.userID, isEqualTo: userID)
         
        let snapshot = try await docRef.getDocuments()
        let vehicles = snapshot.documents.compactMap {
            try? $0.data(as: Vehicle.self)
        }
        return vehicles.map { 
            VehicleAppEntity(
                id: $0.id ?? UUID().uuidString, 
                displayString: $0.name,
                data: $0
            )
        }
    }

    func suggestedEntities() async throws -> [VehicleAppEntity] {
        return try await entities(for: [])
    }
}
