//
//  MainTabView.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 05/10/2023.
//

import SwiftUI
import SwiftData

enum TabSelection: Int, Identifiable, CaseIterable {
    var id: Self { self }
    
    case dashboard = 0
    case odometer = 1
    case settings = 2
}

extension TabSelection {
    // you can make TabSelection :String
    // insteaf of :Int too and remove label
    var label: String {
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
    
    @State var authenticationViewModel = AuthenticationViewModel()
    @State var viewModel = MainTabViewModel()
    
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
    }
    
    /// Save newly acknowledged alert to DB
    /// - Parameter id: alert's id
    private func saveNewAlert(_ id: String) {
        let acknowledgedAlert = AcknowledgedAlert(id: id)
        context.insert(acknowledgedAlert)
    }
}

extension MainTabView {
    private func tabItem(for selection: TabSelection) -> some View {
        Label(selection.label, systemImage: selection.image)
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
    
    /// Returns last column of NavigationSplitView - detail content
    @ViewBuilder
    private func splitViewDetailContent() -> some View {
        if let tabSelection = selectedTabId {
            selectionContent(for: tabSelection)
                .tag(tabSelection)
        } else {
            Text("Unexpected error occured.")
        }
    }
    
    /// Returns NavigationSplitView navigation
    /// primarily used on iPad and Mac devices
    @ViewBuilder
    private func navigationSplitView() -> some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(TabSelection.allCases, selection: $selectedTabId) { tabSelection in
                Label(tabSelection.label, systemImage: tabSelection.image)
            }
            .navigationTitle("Sidebar")
        } detail: {
            splitViewDetailContent()
        }
    }
    
    /// Returns TabView navigation
    /// primarily used on iPhone devices
    @ViewBuilder func tabView() -> some View {
        TabView(selection: $selectedTab) {
            ForEach(TabSelection.allCases) { tabSelection in
                selectionContent(for: tabSelection)
                    .tag(tabSelection)
                    .tabItem {
                        tabItem(for: tabSelection)
                    }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(ActionService.shared)
}
