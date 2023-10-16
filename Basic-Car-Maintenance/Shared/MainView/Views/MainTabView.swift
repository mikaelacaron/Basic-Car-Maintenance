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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showNavigationSplitView = false
    @State private var isShowingRealTimeAlert = false
    @State var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        Group {
            // If the screen is an iPhone or a split screen
            // show a tab view, else show a NavigationSplitView
            if horizontalSizeClass == .compact || showNavigationSplitView == false {
                TabView(selection: $selectedTab) {
                    DashboardView(authenticationViewModel: authenticationViewModel)
                        .tag(TabSelection.dashboard)
                        .tabItem {
                            Label("Dashboard", systemImage: "list.dash.header.rectangle")
                        }
                    
                    OdometerView()
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
            } else {
                NavigationSplitView {
                    List {
                        NavigationLink {
                            DashboardView(authenticationViewModel: authenticationViewModel)
                        } label: {
                            Label("Dashboard", systemImage: "list.dash.header.rectangle")
                        }
                        NavigationLink {
                            OdometerView()
                        } label: {
                            Label("Odometer", systemImage: "gauge")
                        }
                        NavigationLink {
                            SettingsView(authenticationViewModel: authenticationViewModel)
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    }

                } detail: {
                    DashboardView(authenticationViewModel: authenticationViewModel)
                }
            }
        }
        .sheet(isPresented: $isShowingRealTimeAlert) {
            AlertView()
                .presentationDetents([.medium])
        }
        // TODO: To be deleted
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
        // Orientation changed, let's update state to a navigation view if needed
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            showNavigationSplitView = UIDevice.current.orientation.isLandscape
        }
        .onAppear {
            showNavigationSplitView = UIDevice.current.orientation.isLandscape
        }
    }
}

#Preview {
    MainTabView()
        .environment(ActionService.shared)
}
