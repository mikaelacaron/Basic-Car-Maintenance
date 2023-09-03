//
//  DashboardViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/3/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class DashboardViewModel: ObservableObject {
    @Published var events = [MaintenanceEvent]()
    
    func addEvent(_ maintenanceEvent: MaintenanceEvent) async throws {
        try Firestore
            .firestore()
            .collection("maintenance_events")
            .addDocument(from: maintenanceEvent)
    }
}
