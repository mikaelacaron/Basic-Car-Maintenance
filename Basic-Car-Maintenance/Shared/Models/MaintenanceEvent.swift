//
//  MaintenanceEvent.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/25/23.
//

import Foundation

struct MaintenanceEvent: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let date: Date
    let notes: String
}
