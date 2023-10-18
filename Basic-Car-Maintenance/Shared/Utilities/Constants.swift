//
//  Constants.swift
//  Basic-Car-Maintenance
//
//  Created by Justin Seal on 10/13/23.
//

import Foundation

enum FirestoreCollection {
    static let maintenanceEvents = "maintenance_events"
    static let vehicles = "vehicles"
    static let odometerReadings = "odometer_readings"
    static let alerts = "alerts"
}

enum FirestoreField {
    static let userID = "userID"
    static let isOn = "isOn"
    static let id = "_id"
}
