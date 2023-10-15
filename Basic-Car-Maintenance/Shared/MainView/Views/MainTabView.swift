//
//  MainTabView.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 05/10/2023.
//

import SwiftUI
import SwiftData

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
    @State var viewModel: MainTabViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.dashboard)
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle")
                }
            
            OdometerView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.odometer)
                .tabItem {
                    Label("Odometer", systemImage: "gauge")
                }
            
            SettingsView(authenticationViewModel: authenticationViewModel)
                .tag(TabSelection.settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .sheet(isPresented: $isShowingRealTimeAlert) {
            if let alert = viewModel.alert {
                AlertView(alert: alert)
                    .presentationDetents([.medium])
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
        .onAppear {
            viewModel.listenToAlertsUpdates()
        }
        .onChange(of: viewModel.alert) { _, newValue in
            guard newValue != nil else { return }
            isShowingRealTimeAlert = true
        }
    }
    
    init(modelContext: ModelContext) {
        let mainViewModel = MainTabViewModel(modelContext: modelContext)
        self._viewModel = .init(initialValue: mainViewModel)
    }
}

#Preview {
    @Environment(\.modelContext) var modelContext
    
    return MainTabView(modelContext: modelContext)
        .environment(ActionService.shared)
}
