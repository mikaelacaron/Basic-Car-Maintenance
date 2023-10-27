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
}

enum FirestoreField {
    static let userID = "userID"
}

enum SFSymbol {
    // MainTabView
    static let dashboard = "list.dash.header.rectangle"
    static let gauge = "gauge"
    static let gear = "gear"

    // Navigation Items
    static let filter = "line.3.horizontal.decrease.circle"
    static let plus = "plus"
    
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
