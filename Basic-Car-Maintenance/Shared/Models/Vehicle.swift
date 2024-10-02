//
//  Vehicle.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/25/23.
//

import FirebaseFirestoreSwift
import Foundation
import AppIntents

struct Vehicle: Codable, Identifiable, Hashable {
    @DocumentID private var documentID: String?
    var userID: String?
    let name: String
    let make: String
    let model: String
    let year: String?
    let color: String?
    let vin: String?
    let licensePlateNumber: String?
    var displayRepresentation: DisplayRepresentation { DisplayRepresentation(title: "\(name)") }
    
    static var defaultQuery = VehicleQuery()
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Vehicle")
    
    init(
        id: String? = nil,
        userID: String? = nil,
        name: String,
        make: String,
        model: String,
        year: String? = nil,
        color: String? = nil,
        vin: String? = nil,
        licensePlateNumber: String? = nil
    ) {
        self.documentID = id
        self.userID = userID
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.color = color
        self.vin = vin
        self.licensePlateNumber = licensePlateNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case documentID = "_id"
        case userID
        case name
        case make
        case model
        case year
        case color
        case vin
        case licensePlateNumber
    }
}

extension Vehicle: AppEntity {
    var id: String {
        documentID ?? UUID().uuidString
    }
}
