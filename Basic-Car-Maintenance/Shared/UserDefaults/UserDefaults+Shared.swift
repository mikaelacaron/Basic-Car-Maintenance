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
        guard let shared = UserDefaults(suiteName: "group.com.aking.Basic-Car-Maintenance") else {
            fatalError("Ensure that your app is properly configured for sharing user defaults.")
        }
        
        return shared
    }
}
