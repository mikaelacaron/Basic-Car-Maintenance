//
//  Bundle+extension.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import Foundation

extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
