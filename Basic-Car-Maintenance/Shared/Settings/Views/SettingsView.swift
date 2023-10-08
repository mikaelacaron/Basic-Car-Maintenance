//
//  SettingsView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: SettingsViewModel
    @State private var isShowingAddVehicle = false
    @State private var showDeleteVehicleError = false
    @State var errorDetails: Error?
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    init(authenticationViewModel: AuthenticationViewModel) {
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(authenticationViewModel: authenticationViewModel)) // swiftlint:disable:this line_length
        self.authenticationViewModel = authenticationViewModel
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
                            .frame(width: 20, height: 20)
                    }
                }
                
                // swiftlint:disable:next line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=feature+request&projects=&template=feature-request.md&title=FEATURE+-")!) {
                    Label {
                        Text("Request a New Feature", comment: "Link to request a new feature.")
                    } icon: {
                        Image(systemName: "doc.badge.plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                // swiftlint:disable:next line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=bug&projects=&template=bug-report.md&title=BUG+-")!) {
                    Label {
                        Text("Report a Bug", comment: "Link to report a bug")
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
                        AuthenticationView(viewModel: authenticationViewModel)
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
    }
}

#Preview {
    SettingsView(authenticationViewModel: AuthenticationViewModel())
}
