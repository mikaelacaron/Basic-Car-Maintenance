//
//  OdometerReading.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import FirebaseFirestore

struct OdometerReading: Codable, Identifiable, Hashable, Equatable {
    @DocumentID var id: String?
    var userID: String?
    let date: Date
    let distance: Int
    let isMetric: Bool
    let vehicleID: String
    
    static func == (lhs: OdometerReading, rhs: OdometerReading) -> Bool {
            return lhs.userID == rhs.userID &&
                   lhs.date == rhs.date &&
                   lhs.distance == rhs.distance &&
                   lhs.vehicleID == rhs.vehicleID
        }
}
