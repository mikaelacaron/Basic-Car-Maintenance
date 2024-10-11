//
//  UserDefaults+Shared.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

extension UserDefaults {
    /// Returns a UserDefaults instance associtated with an app group.
    static var shared: UserDefaults {
        guard let shared = UserDefaults(suiteName: "group.com.<your-company>.Basic-Car-Maintenance") else {
            fatalError("Ensure that your app/extension is properly configured for sharing user defaults.")
        }
        
        return shared
    }
}
