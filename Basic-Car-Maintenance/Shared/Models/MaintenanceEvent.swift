//
//  MaintenanceEvent.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/25/23.
//

import FirebaseFirestore
import Foundation

struct MaintenanceEvent: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userID: String?
    
    let vehicleID: String
    let title: String
    let date: Date
    let notes: String
}
