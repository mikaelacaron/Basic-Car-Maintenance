//
//  BasicCarMaintenanceApp.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/11/23.
//

import FirebaseCore
import SwiftUI

@main
struct BasicCarMaintenanceApp: App {
    
    @StateObject var authenticationViewModel: AuthenticationViewModel
    
    init() {
        FirebaseApp.configure()
        _authenticationViewModel = StateObject(wrappedValue: AuthenticationViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView(authenticationViewModel: authenticationViewModel)
                    .tabItem {
                        Label("Dashboard", systemImage: "list.dash.header.rectangle")
                    }
                
                SettingsView(authenticationViewModel: authenticationViewModel)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
