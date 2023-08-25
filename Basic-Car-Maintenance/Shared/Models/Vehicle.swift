//
//  Vehicle.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/25/23.
//

import Foundation

struct Vehicle: Codable, Identifiable {
    let id: UUID
    let name: String
    let make: String
    let model: String
}
