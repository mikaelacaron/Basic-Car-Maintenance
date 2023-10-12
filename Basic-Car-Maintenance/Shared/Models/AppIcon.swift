//
//  AppIcon.swift
//  Basic-Car-Maintenance
//
//  Created by Daniel Lyons on 10/11/23.
//
import UIKit
import Observation

/// The ViewModel responsible for allowing users to change the AppIcon
@Observable class ChangeAppIconViewModel {
  var selectedAppIcon: AppIcon
  
  init() {
    if let iconName = UIApplication.shared.alternateIconName,
       let appIcon = AppIcon(rawValue: iconName) {
      self.selectedAppIcon = appIcon
    } else {
      self.selectedAppIcon = .primary
    }
  }
  
  func updateAppIcon(to icon: AppIcon) {
    let previousAppIcon = selectedAppIcon
    selectedAppIcon = icon
    
    Task { @MainActor in
      guard UIApplication.shared.alternateIconName != icon.iconName else {
        // No need to update since we're already using this icon.
        return
      }
      
      do {
        try await UIApplication.shared.setAlternateIconName(icon.iconName)
      } catch {
        // We're only logging the error here and not actively handling the app icon failure
        // since it's very unlikely to fail.
        print("Updating icon to \(String(describing: icon.iconName)) failed.")
        
        // Restore previous app icon
        selectedAppIcon = previousAppIcon
      }
    }
  }
}

enum AppIcon: String, CaseIterable, Identifiable {
  case primary = "AppIcon"
  case carDark = "AppIcon-car-dark"
  case carRed = "AppIcon-car-red"
  case carYellow = "AppIcon-car-yellow"
  case carBlack = "AppIcon-car-black"
  case carOrange = "AppIcon-car-orange"
  
  var id: String{ rawValue }
  var iconName: String? {
    switch self {
      /// returns `nil`. Use this case to reset the app icon back to its primary icon.
      case .primary:
        return nil
      default:
        return rawValue
    }
  }
  
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
    UIImage(named: rawValue + "-Preview") ?? UIImage()
  }
}
