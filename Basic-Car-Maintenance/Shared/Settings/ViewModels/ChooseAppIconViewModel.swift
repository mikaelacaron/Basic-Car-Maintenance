import UIKit
import Observation

/// The ViewModel responsible for allowing users to change the AppIcon
@Observable class ChooseAppIconViewModel {
  private(set) var selectedAppIcon: AppIcon
  
  init() {
    if let iconName = UIApplication.shared.alternateIconName,
       let appIcon = AppIcon(rawValue: iconName) {
      self._selectedAppIcon = appIcon
    } else {
      self._selectedAppIcon = .primary
    }
  }
  
  func updateAppIcon(to icon: AppIcon) {
    let previousAppIcon = selectedAppIcon
    selectedAppIcon = icon
    
    Task { @MainActor in
      guard UIApplication.shared.alternateIconName != icon.iconName else {
        print("No need to update icon since we're already using this icon.")
        return
      }
      
      do {
        try await UIApplication.shared.setAlternateIconName(icon.iconName)
        print("Successfully updated icon.")
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
