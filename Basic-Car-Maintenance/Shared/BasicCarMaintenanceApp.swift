//
//  BasicCarMaintenanceApp.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/11/23.
//

import SwiftUI

@main
struct BasicCarMaintenanceApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "list.dash.header.rectangle")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
