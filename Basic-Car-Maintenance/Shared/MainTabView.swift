//
//  MainTabView.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 05/10/2023.
//

import SwiftUI

enum TabSelection: Int {
    case dashboard = 0
    case settings = 1
}

struct MainTabView: View {
    @EnvironmentObject var actionService: ActionService
    @Environment(\.scenePhase) var scenePhase
    @State var authenticationViewModel = AuthenticationViewModel()
    @State var selectedTab: TabSelection = .dashboard
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.dashboard)
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle")
                }
            
            SettingsView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            guard
                case .active = newScenePhase,
                let action = actionService.action
            else { return }
            
            // select the tab where the desired view is located to make sure
            // it is presented from the proper hierarchy.
            switch action {
            case .newMaintenance:
                selectedTab = .dashboard
            case .addVehicle:
                selectedTab = .settings
            }
        }
    }
}

#Preview {
    MainTabView()
}
