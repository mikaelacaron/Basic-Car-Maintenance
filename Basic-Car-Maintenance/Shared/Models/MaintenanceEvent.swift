//
//  MaintenanceEvent.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
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
