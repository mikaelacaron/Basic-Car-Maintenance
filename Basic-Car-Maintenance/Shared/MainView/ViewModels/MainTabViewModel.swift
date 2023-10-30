//
//  MainTabViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 13/10/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable
final class MainTabViewModel: ObservableObject, VehiclesProtocol {
    @MainActor var alert: AlertItem?
    
    /// Update the UI once a new alert is sent
    func fetchNewestAlert(ignoring acknowledgedAlerts: [String]) {
        
        var query = Firestore
            .firestore()
            .collection(FirestoreCollection.alerts)
            .whereField(FirestoreField.isOn, isEqualTo: true)
            .limit(to: 1)
        
        if !acknowledgedAlerts.isEmpty {
            query = query
                .whereField(FirestoreField.id, notIn: acknowledgedAlerts)
        }
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self,
                  error == nil,
                  let documents = snapshot?.documents else {
                return
            }
            
            let newAlert = documents
                .compactMap {
                    do {
                        return try $0.data(as: AlertItem.self)
                    } catch {
                        print("Error decoding to AlertItem: ", error)
                        return nil
                    }
                }
                .first
            
            if let newAlert {
                Task { @MainActor in
                    self.alert = newAlert
                }
            }
        }
    }
}

/// Share common UI items across the views
@Observable
final class AppSharedInfo: ObservableObject {
    var vehicles = [Vehicle]()
}

protocol VehiclesProtocol {
    func getVehicles() async -> [Vehicle]
}

extension VehiclesProtocol {
    func getVehicles() async -> [Vehicle] {
        guard let uid = AppDefaults.getUserID() else { return [] }
        let db = Firestore.firestore()
        let docRef = db.collection(FirestoreCollection.vehicles)
            .whereField(FirestoreField.userID, isEqualTo: uid)
        
        guard let querySnapshot = try? await docRef.getDocuments() else { return [] }
        
        let vehicles = querySnapshot.documents.compactMap { try? $0.data(as: Vehicle.self) }
        return vehicles
    }
}
