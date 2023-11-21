//
//  EditVehicleEvent.swift
//  Basic-Car-Maintenance
//
//  Created by Traton Gossink on 11/18/23.
//

import FirebaseFirestoreSwift
import Foundation

struct EditVehicleEvent: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userID: String?
    let name: String
    let make: String
    let model: String
    let year: String
    let color: String
    let VIN: String
    let licenseplatenumber: String
    var vehicle: Vehicle?
}
