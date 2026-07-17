//
//  MainTabViewModel.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import FirebaseFirestore

@Observable
class MainTabViewModel {
    @MainActor var alert: AlertItem?
    
    /// Update the UI once a new alert is sent
    func fetchNewestAlert(ignoring acknowledgedAlerts: [String]) async {
        
        var query = Firestore
            .firestore()
            .collection(FirestoreCollection.alerts)
            .whereField(FirestoreField.isOn, isEqualTo: true)
            .limit(to: 1)
        
        if !acknowledgedAlerts.isEmpty {
            query = query
                .whereField(FirestoreField.id, notIn: acknowledgedAlerts)
        }
        
        do {
          let snapshot = try await query.getDocuments()
            
            let newAlert = snapshot.documents
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

        } catch {
          print("Error getting documents: \(error)")
        }
    }
}
