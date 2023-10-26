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
    //Tabview icons
    static let dashboard = "list.dash.header.rectangle"
    static let odometer = "gauge"
    static let settings = "gear"

    //Navigation header icons
    static let filter = "line.3.horizontal.decrease.circle"
    static let add = "plus"
    
    //Dashboard icons
    static let trash = "trash"
    static let edit = "pencil"
    static let magnifyingglass = "magnifyingglass"
    
    //Settings icons
    static let document = "doc.badge.plus"
    static let reportbug = "ladybug"
    static let contributors = "person.3.fill"
    static let profile = "person"
    static let appIcon = "apps.iphone"
    
    //ChoseAopIcon View icons
    static let checkmark = "checkmarkImage"
    
    //ContributorsProfileView icon
    static let personcircle = "person.circle.fill"
  
}
