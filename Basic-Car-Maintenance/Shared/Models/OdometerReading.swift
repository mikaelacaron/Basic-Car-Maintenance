//
//  OdometerReading.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import FirebaseFirestoreSwift

struct OdometerReading: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userID: String?
    let date: Date
    let distance: Int
    let isMetric: Bool
    let vehicleID: String
}
