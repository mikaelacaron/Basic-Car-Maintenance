//
//  Action.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 05/10/2023.
//
import FirebaseAnalytics
import UIKit

enum ActionType: String {
    case newMaintenance = "NewMaintenance"
    case addVehicle = "AddVehicle"
}

enum Action: Equatable {
    case newMaintenance
    case addVehicle
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let type = ActionType(rawValue: shortcutItem.type) else {
            return nil
        }
        
        switch type {
        case .newMaintenance:
            self = .newMaintenance
        case .addVehicle:
            self = .addVehicle
        }
    }
}
