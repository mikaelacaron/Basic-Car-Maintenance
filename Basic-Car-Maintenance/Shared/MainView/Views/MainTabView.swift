//
//  MainTabView.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 05/10/2023.
//

import SwiftUI

enum TabSelection: Int {
    case dashboard = 0
    case odometer = 1
    case settings = 2
}

@MainActor
struct MainTabView: View {
    @AppStorage("lastTabOpen") var selectedTab = TabSelection.dashboard
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @State private var isShowingRealTimeAlert = false
    @State var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.dashboard)
                .tabItem {
                    Label("Dashboard", systemImage: SFSymbol.dashboard)
                }
            
            OdometerView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.odometer)
                .tabItem {
                    Label("Odometer", systemImage: SFSymbol.odometer)
                }
            
            SettingsView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.settings)
                .tabItem {
                    Label("Settings", systemImage: SFSymbol.settings)
                }
        }
        .sheet(isPresented: $isShowingRealTimeAlert) {
            AlertView()
                .presentationDetents([.medium])
        }
        .onTapGesture(count: 2) {
            isShowingRealTimeAlert = true
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
        .environment(ActionService.shared)
}
