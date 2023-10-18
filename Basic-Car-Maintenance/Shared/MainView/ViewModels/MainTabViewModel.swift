//
//  MainTabViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 13/10/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftData

@Observable
class MainTabViewModel {
    @MainActor var alert: AlertItem?
    
    /// Update the UI once a new alert is sent
    func listenToAlertsUpdates(ignoring acknowledgedAlerts: [String]) {
        
        var query = Firestore
            .firestore()
            .collection(FirestoreCollection.alerts)
            .whereField(FirestoreField.isOn, isEqualTo: true)
            .limit(to: 1)
        
        if !acknowledgedAlerts.isEmpty {
            query = query
                .whereField(FirestoreField.id, notIn: acknowledgedAlerts)
        }
        
        query.addSnapshotListener {[weak self] snapshot, error in
            guard
                let self,
                error == nil,
                let documents = snapshot?.documents
            else { return }
            
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
