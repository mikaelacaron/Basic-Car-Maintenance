//
//  Vehicle.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/25/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Vehicle: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userID: String?
    let name: String
    let make: String
    let model: String
    let year: String?
    let color: String?
    let vin: String?
    let licensePlateNumber: String?
    
    init(id: String? = nil,
         userID: String? = nil,
         name: String,
         make: String,
         model: String,
         year: String? = nil,
         color: String? = nil,
         vin: String? = nil,
         licensePlateNumber: String? = nil) {
        self.id = id
        self.userID = userID
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.color = color
        self.vin = vin
        self.licensePlateNumber = licensePlateNumber
    }
}
