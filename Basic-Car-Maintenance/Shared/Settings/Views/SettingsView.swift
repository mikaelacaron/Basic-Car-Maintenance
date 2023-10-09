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
    
    init(authenticationViewModel: AuthenticationViewModel) {
        let settingsViewModel = SettingsViewModel(authenticationViewModel: authenticationViewModel)
        _viewModel = .init(initialValue: settingsViewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Thanks for using this app! It's open source and anyone can contribute to it.")
                
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance")!) {
                    Label {
                        Text("GitHub Repo")
                    } icon: {
                        Image("github-logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }        

                // swiftlint:disable:next line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=feature+request&projects=&template=feature-request.md&title=FEATURE+-")!) {
                    Label {
                        Text("Request a New Feature")
                    } icon: {
                        Image(systemName: "doc.badge.plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }

                // swiftlint:disable:next line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=bug&projects=&template=bug-report.md&title=BUG+-")!) {
                    Label {
                        Text("Report a Bug")
                    } icon: {
                        Image(systemName: "ladybug")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                NavigationLink {
                    ContributorsListView(viewModel: viewModel)
                } label: {
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("Contributors")
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
                            Button("Delete", role: .destructive) {
                                Task {
                                    do {
                                        try await viewModel.deleteVehicle(vehicle)
                                    } catch {
                                        errorDetails = error
                                        showDeleteVehicleError = true
                                    }
                                }
                            }
                        }
                    }
                    
                    Button {
                        isShowingAddVehicle.toggle()
                    } label: {
                        Text("Add Vehicle")
                    }
                } header: {
                    Text("Vehicles")
                }
                
                Section {
                    NavigationLink {
                        AuthenticationView(viewModel: viewModel.authenticationViewModel)
                    } label: {
                        Label {
                            Text("Profile")
                        } icon: {
                            Image(systemName: "person")
                        }
                    }
                }
                
                Text("Version \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))")
            }
            .alert("Failed To Delete Vehicle", isPresented: $showDeleteVehicleError) {
                Button("OK") {
                    showDeleteVehicleError = false
                }
            } message: {
                if let errorDetails {
                    Text("Failed To Delete Vehicle\nDetails:\(errorDetails.localizedDescription)")
                } else {
                    Text("Failed To Add Vehicle. Unknown Error.")
                }
            }
            .navigationTitle(Text("Settings"))
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
