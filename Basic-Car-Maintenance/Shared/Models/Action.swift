//
//  Action.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 05/10/2023.
//

import UIKit

enum ActionType: String {
    case newMaintenance = "NewMaintenance"
    case addVehicle = "AddVehicle"
    case addOdometerReading = "AddOdometerReading"
}

enum Action: Equatable {
    case newMaintenance
    case addVehicle
    case addOdometerReading
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let type = ActionType(rawValue: shortcutItem.type) else {
            return nil
        }
        
        switch type {
        case .newMaintenance:
            self = .newMaintenance
        case .addVehicle:
            self = .addVehicle
        case .addOdometerReading:
            self = .addOdometerReading
        }
    }
}
