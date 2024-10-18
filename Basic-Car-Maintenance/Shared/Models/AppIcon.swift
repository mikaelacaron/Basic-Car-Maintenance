//
//  ChooseAppIconView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import UIKit

enum AppIcon: String, CaseIterable, Identifiable {
    case primary = "AppIcon"
    case carRed = "AppIcon-car-red"
    case carYellow = "AppIcon-car-yellow"
    case carBlack = "AppIcon-car-black"
    case carOrange = "AppIcon-car-orange"
    
    var id: String { rawValue }
    
    /// the name of the icon in the App Bundle.
    var iconName: String? {
        switch self {
            /// returns `nil`. Use this case to reset the app icon back to its primary icon.
        case .primary:
            return nil
        default:
            return rawValue
        }
    }
    
    /// A UI presentable string.
    var description: String {
        switch self {
        case .primary:
            return "Default"
        case .carRed:
            return "Red Car"
        case .carYellow:
            return "Yellow Car"
        case .carBlack:
            return "Black Car"
        case .carOrange:
            return "Orange Car"
        }
    }
    
    var previewImage: String {
        switch self {
        case .primary:
            return "Preview-appIcon"
        case .carRed:
            return "Preview-car-red"
        case .carYellow:
            return "Preview-car-yellow"
        case .carBlack:
            return "Preview-car-black"
        case .carOrange:
            return "Preview-car-orange"
        }
    }
}
