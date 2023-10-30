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

struct MainTabView: View {
    @Query var acknowledgedAlerts: [AcknowledgedAlert]
    
    @Environment(ActionService.self) var actionService
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("lastTabOpen") var selectedTab = TabSelection.dashboard
    
    @StateObject private var sharedInfo = AppSharedInfo()
    @State var authenticationViewModel = AuthenticationViewModel()
    @StateObject var viewModel = MainTabViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tag(TabSelection.dashboard)
                .tabItem {
                    Label("Dashboard", systemImage: SFSymbol.dashboard)
                }
            
            OdometerView()
                .tag(TabSelection.odometer)
                .tabItem {
                    Label("Odometer", systemImage: SFSymbol.gauge)
                }
            
            SettingsView()
                .tag(TabSelection.settings)
                .tabItem {
                    Label("Settings", systemImage: SFSymbol.gear)
                }
        }
        .environment(sharedInfo)
        .sheet(item: $viewModel.alert) { alert in
            AlertView(alert: alert)
                .presentationDetents([.medium])
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
            viewModel.fetchNewestAlert(ignoring: acknowledgedAlerts.map(\.id))
        }
        .onChange(of: viewModel.alert) { _, newValue in
            guard let id = newValue?.id else { return }
            saveNewAlert(id)
        }
        .task {
            self.sharedInfo.vehicles = await viewModel.getVehicles()
        }
    }
    
    /// Save newly acknowledged alert to DB
    /// - Parameter id: alert's id
    private func saveNewAlert(_ id: String) {
        let acknowledgedAlert = AcknowledgedAlert(id: id)
        context.insert(acknowledgedAlert)
    }
}

#Preview {
    MainTabView()
        .environment(ActionService.shared)
}
