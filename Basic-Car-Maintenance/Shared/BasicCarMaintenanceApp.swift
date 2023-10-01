//
//  BasicCarMaintenanceApp.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/11/23.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct BasicCarMaintenanceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView(authenticationViewModel: authenticationViewModel)
                    .tabItem {
                        Label("Dashboard", systemImage: "list.dash.header.rectangle")
                    }
                
                SettingsView()
                    .environmentObject(authenticationViewModel)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
