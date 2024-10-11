//
//  MainTabView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftData
import SwiftUI

enum TabSelection: Int, Identifiable, CaseIterable {
    var id: Self { self }
    
    case dashboard = 0
    case odometer = 1
    case settings = 2
}

extension TabSelection {
    var label: LocalizedStringKey {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .odometer:
            return "Odometer"
        case .settings:
            return "Settings"
        }
    }
    
    var image: String {
        switch self {
        case .dashboard:
            return SFSymbol.dashboard
        case .odometer:
            return SFSymbol.gauge
        case .settings:
            return SFSymbol.gear
        }
    }
}

@MainActor
struct MainTabView: View {
    @Query var acknowledgedAlerts: [AcknowledgedAlert]
    
    @Environment(ActionService.self) var actionService
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("lastTabOpen") var selectedTab = TabSelection.dashboard
    
    @State private var selectedTabId: TabSelection.ID? = .dashboard
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    @State private var authenticationViewModel = AuthenticationViewModel()
    @State private var viewModel = MainTabViewModel()
    
    init() {
        _selectedTabId = State(initialValue: selectedTab)
    }
    
    var body: some View {
        Group {
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                navigationSplitView()
            } else {
                tabView()
            }
            #else
            navigationSplitView()
            #endif
        }
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
        .onChange(of: selectedTabId ?? TabSelection.dashboard) { _, newValue in
            selectedTab = newValue
        }
    }
    
    /// Save newly acknowledged alert to DB
    /// - Parameter id: alert's id
    private func saveNewAlert(_ id: String) {
        let acknowledgedAlert = AcknowledgedAlert(id: id)
        context.insert(acknowledgedAlert)
    }
    
    /// Save screen content for specific selection
    /// - Parameter selection: tab selection enum value
    @ViewBuilder
    private func selectionContent(for selection: TabSelection) -> some View {
        switch selection {
        case .dashboard:
            DashboardView(userUID: authenticationViewModel.user?.uid)
        case .odometer:
            OdometerView(userUID: authenticationViewModel.user?.uid)
        case .settings:
            SettingsView(authenticationViewModel: authenticationViewModel)
        }
    }
        
    /// Primarily used on iPad and Mac devices
    /// - Returns: `NavigationSplitView` navigation
    @ViewBuilder
    private func navigationSplitView() -> some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(TabSelection.allCases, selection: $selectedTabId) { tabSelection in
                Label(tabSelection.label, systemImage: tabSelection.image)
            }
            .navigationTitle("Basic Car")
        } detail: {
            if let tabSelection = selectedTabId {
                selectionContent(for: tabSelection)
                    .tag(tabSelection)
            }
        }
    }
    
    /// Primarily used on iPhone devices
    /// - Returns: `TabView` navigation
    @ViewBuilder func tabView() -> some View {
        TabView(selection: $selectedTab) {
            ForEach(TabSelection.allCases) { tabSelection in
                selectionContent(for: tabSelection)
                    .tag(tabSelection)
                    .tabItem {
                        Label(tabSelection.label, systemImage: tabSelection.image)
                    }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(ActionService.shared)
}
