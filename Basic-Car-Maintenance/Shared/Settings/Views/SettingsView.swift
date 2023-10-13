//
//  SettingsView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel
    @State private var isShowingAddVehicle = false
    @State private var showDeleteVehicleError = false
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @State private var errorDetails: Error?
    @ScaledMetric var scale: CGFloat = 1
    
    init(authenticationViewModel: AuthenticationViewModel) {
        let settingsViewModel = SettingsViewModel(authenticationViewModel: authenticationViewModel)
        _viewModel = .init(initialValue: settingsViewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // swiftlint:disable:next line_length
                Text("Thanks for using this app! It's open source and anyone can contribute to it.", comment: "Thanks a user for using the app and tells the user they can contribute to the codebase")
                
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance")!) {
                    Label {
                        Text("GitHub Repo", comment: "Link to the Basic Car Maintenance GitHub repo.")
                    } icon: {
                        Image("github-logo")
                            .resizable()
                            .frame(width: 20 * scale, height: 20 * scale)
                    }
                }
              
                Link(destination: URL(string: "https://github.com/mikaelacaron")!) {
                    Text("🦄 Mikaela Caron - Maintainer", comment: "Link to maintainer Github account.")
                }

                // swiftlint:disable:next line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=feature+request&projects=&template=feature-request.md&title=FEATURE+-")!) {
                    Label {
                        Text("Request a New Feature", comment: "Link to request a new feature.")
                    } icon: {
                        Image(systemName: "doc.badge.plus")
                            .resizable()
                            .frame(width: 20 * scale, height: 20 * scale)
                    }
                }
                // swiftlint:disable:next line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=bug&projects=&template=bug-report.md&title=BUG+-")!) {
                    Label {
                        Text("Report a Bug", comment: "Link to report a bug")
                    } icon: {
                        Image(systemName: "ladybug")
                            .resizable()
                            .frame(width: 20 * scale, height: 20 * scale)
                    }
                }
                
                NavigationLink {
                    ContributorsListView(viewModel: viewModel)
                } label: {
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("Contributors", comment: "Link to contributors list.")
                    }
                }
                
                Section {
                    ForEach(viewModel.vehicles) { vehicle in
                        VStack {
                            Text(vehicle.name)
                                .font(.headline)
                            
                            Text(vehicle.make)
                            
                            Text(vehicle.model)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    do {
                                        try await viewModel.deleteVehicle(vehicle)
                                    } catch {
                                        errorDetails = error
                                        showDeleteVehicleError = true
                                    }
                                }
                            } label: {
                                Text("Delete", comment: "Label to delete a vehicle")
                            }
                        }
                    }
                    
                    Button {
                        isShowingAddVehicle.toggle()
                    } label: {
                        Text("Add Vehicle", comment: "Label to add a vehicle.")
                    }
                } header: {
                    Text("Vehicles", comment: "Label to display header title.")
                }
                
                Section {
                    NavigationLink {
                        AuthenticationView(viewModel: viewModel.authenticationViewModel)
                    } label: {
                        Label {
                            Text("Profile", comment: "Link to view profile.")
                        } icon: {
                            Image(systemName: "person")
                        }
                    }
                }
                // swiftlint:disable:next line_length
                Text("Version \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))", comment: "Label to display version and build number.")
            }
            // swiftlint:disable:next line_length
            .alert(Text("Failed To Delete Vehicle", comment: "Label to dsplay title of the delete vehicle alert"),
                   isPresented: $showDeleteVehicleError) {
                Button {
                    showDeleteVehicleError = false
                } label: {
                    Text("OK", comment: "Label to dismiss alert")
                }
            } message: {
                if let errorDetails {
                    // swiftlint:disable:next line_length
                    Text("Failed To Delete Vehicle\nDetails:\(errorDetails.localizedDescription)", comment: "Label to display localized error description.")
                } else {
                    Text("Failed To Add Vehicle. Unknown Error.", comment: "Label to display error details.")
                }
            }
            .navigationTitle(Text("Settings", comment: "Label to display settings."))
            .task {
                await viewModel.getVehicles()
            }
            .sheet(isPresented: $isShowingAddVehicle) {
                AddVehicleView() { vehicle in
                    Task {
                        await viewModel.addVehicle(vehicle)
                    }
                }
            }
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            guard case .active = newScenePhase else { return }
            
            guard let action = actionService.action,
                  action == .addVehicle
            else {
                // another action has been triggered
                // so we will need to dismiss the current presented view
                isShowingAddVehicle = false
                return
            }
            
            // if the view is already presented, do nothing
            guard !isShowingAddVehicle else { return }
            // delay the presentation of the view a bit
            // to make sure the already presented view is dismissed.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isShowingAddVehicle = true
            }
        }
    }
}

#Preview {
    SettingsView(authenticationViewModel: AuthenticationViewModel())
}
