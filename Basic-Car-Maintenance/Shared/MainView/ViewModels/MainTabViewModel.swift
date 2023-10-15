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
    private var acknowledgedAlerts = [AcknowledgedAlert]()
    @MainActor var alert: AlertItem?
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchAcknowledgedAlerts()
    }
    
    /// Update the UI once a new alert is sent
    func listenToAlertsUpdates() {
        var query = Firestore
            .firestore()
            .collection("alerts")
            .whereField("isOn", isEqualTo: true)
            .limit(to: 1)
        
        if !acknowledgedAlerts.isEmpty {
            query = query
                .whereField("_id", notIn: self.acknowledgedAlerts.map(\.id) as [String])
        }
        
        query.addSnapshotListener {[weak self] snapShot, error in
            guard
                let self,
                error == nil,
                let documents = snapShot?.documents
            else { return }
            
            let newAlert = documents
                .compactMap {
                    do {
                        return try $0.data(as: AlertItem.self)
                    } catch {
                        print("Error decoding to AlertItem: ", error.localizedDescription)
                        return nil
                    }
                }
                .first
            
            if let newAlert,
               let newAlertId = newAlert.id {
                Task { @MainActor in
                    self.alert = newAlert
                }
                saveNewAlert(id: newAlertId)
            }
        }
    }
    
    /// Retrieve previously acknowledged alerts from DB
    private func fetchAcknowledgedAlerts() {
        let descriptor = FetchDescriptor<AcknowledgedAlert>()
        do {
            let acknowledgedAlerts = try modelContext.fetch(descriptor)
            self.acknowledgedAlerts = acknowledgedAlerts
        } catch {
            print("Fetching AcknowledgedAlert failed: ", error.localizedDescription)
        }
        
    }
    
    /// Save newly acknowledged alert to DB
    /// - Parameter id: alert's id
    private func saveNewAlert(id: String) {
        let acknowledgedAlert = AcknowledgedAlert(id: id)
        modelContext.insert(acknowledgedAlert)
    }
}
