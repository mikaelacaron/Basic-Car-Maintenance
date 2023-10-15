//
//  OdometerReading.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import Foundation
import FirebaseFirestoreSwift

struct OdometerReading: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userID: String?
    let date: Date
    let distance: Int
    let unitsAreMetric: Bool
    let vehicle: Vehicle
}
