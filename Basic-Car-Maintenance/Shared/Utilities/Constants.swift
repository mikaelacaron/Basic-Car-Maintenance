//
//  Constants.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

// swiftlint:disable line_length

enum FirestorePath {
    
    /// `vehicles/{ vehicleDocumentID }/maintenance_events/{ maintenceEventDocumentID }`
    case maintenanceEvents(vehicleID: String)
    
    /// `vehicles/{ vehicleDocumentID }/odometer_readings/{ maintenceEventDocumentID }`
    case odometerReadings(vehicleID: String)
    
    var path: String {
        switch self {
        case let .maintenanceEvents(vehicleID):
            return "\(FirestoreCollection.vehicles)/" + "\(vehicleID)/" + FirestoreCollection.maintenanceEvents
        case let .odometerReadings(vehicleID):
            return "\(FirestoreCollection.vehicles)/" + "\(vehicleID)/" + FirestoreCollection.odometerReadings
        }
    }
}

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

enum GitHubURL {
    static let mikaelaCaronProfile = URL(string: "https://github.com/mikaelacaron")!
    
    static let repo = URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance")!
    
    static let apiContributors = URL(string: "https://api.github.com/repos/mikaelacaron/Basic-Car-Maintenance/contributors")!
    
    static let featureRequest = URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=feature+request&projects=&template=feature-request.md&title=FEATURE+-")!
    
    static let bugReport = URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=bug&projects=&template=bug-report.md&title=BUG+-")!
    
    static let privacy = URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance-Privacy")!
}

enum SFSymbol {
    // MainTabView
    static let dashboard = "list.dash.header.rectangle"
    static let gauge = "gauge"
    static let gear = "gear"

    // Navigation Items
    static let filter = "line.3.horizontal.decrease.circle"
    static let plus = "plus"
    static let share = "square.and.arrow.up"
    
    // Dashboard
    static let trash = "trash"
    static let pencil = "pencil"
    static let magnifyingGlass = "magnifyingglass"
    
    // Settings
    static let document = "doc.badge.plus"
    static let ladybug = "ladybug"
    static let contributors = "person.3.fill"
    static let person = "person"
    static let iPhoneWithApps = "apps.iphone"
    
    // ChoseAopIcon View
    static let checkmarkFill = "checkmark.circle.fill"
    static let circle = "circle"

    // ContributorsProfileView
    static let personCircle = "person.circle.fill"
  
}

enum AppStorageKeys {
    static let measurementSystem = "defaultMeasurementSystem"
}

// swiftlint:enable line_length
