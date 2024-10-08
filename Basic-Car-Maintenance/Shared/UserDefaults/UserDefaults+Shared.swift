//
//  UserDefaults+Shared.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        // Not sure of a great way to grab the group id here
        guard let shared = UserDefaults(suiteName: "group.com.<your-company>.Basic-Car-Maintenance") else {
            fatalError("Ensure that your app is properly configured for sharing user defaults.")
        }
        
        return shared
    }
}
