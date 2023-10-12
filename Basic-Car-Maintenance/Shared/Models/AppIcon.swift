//
//  ChooseAppIconView.swift
//  Basic-Car-Maintenance
//
//  Created by Daniel Lyons on 10/11/23.
//

import UIKit

enum AppIcon: String, CaseIterable, Identifiable {
  case primary = "AppIcon"
  case carDark = "AppIcon-car-dark"
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
    case .carDark:
      return "Dark Mode"
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
  
  var preview: UIImage {
    UIImage(named: rawValue) ?? UIImage()
  }
}
