//
//  Action.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

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
