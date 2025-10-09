//
//  BasicCarMaintenanceWidgetBundle.swift
//  Basic-Car-Maintenance-Widget
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//
import FirebaseAuth
import Firebase
import WidgetKit
import SwiftUI

@main
struct BasicCarMaintenanceWidgetBundle: WidgetBundle {
    var body: some Widget {
        BasicCarMaintenanceWidget()
    }
    
    init() {
        // Since this widget access Firebase, the same configuration as the main application is needed. 
        FirebaseApp.configure()
                  
        
        try? Auth.auth().useUserAccessGroup(Bundle.main.keychainAccessGroup)
        let useEmulator = true
        if useEmulator {
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
            
            Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
        }
    }
}
