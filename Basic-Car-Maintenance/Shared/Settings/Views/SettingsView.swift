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
            // swiftlint:disable:all line_length
            Form {
                Text("Thanks for using this app! It's open source and anyone can contribute to it.", comment: "Thanks a user for using the app and provides the app description")
                
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance")!) {
                    Label {
                        Text("GitHub Repo", comment: "Lets a user access the Basic-Car-Maintenance github repo.")
                    } icon: {
                        Image("github-logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                // swiftlint:disable:all line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=feature+request&projects=&template=feature-request.md&title=FEATURE+-")!) {
                    Label {
                        Text("Request a New Feature", comment: "Lets a user request a new feature.")
                    } icon: {
                        Image(systemName: "doc.badge.plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                // swiftlint:disable:all line_length
                Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=bug&projects=&template=bug-report.md&title=BUG+-")!) {
                    Label {
                        Text("Report a Bug", comment: "Lets a user to report a bug.")
                    } icon: {
                        Image(systemName: "ladybug")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                NavigationLink {
                    ContributorsListView(viewModel: viewModel)
                } label: {
                    // swiftlint:disable:all line_length
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("Contributors", comment: "Lets the user access contributors list screen.")
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
                                Text("Delete", comment: "Lets a user to perform a delete action.")
                            }
                        }
                    }
                    
                    Button {
                        isShowingAddVehicle.toggle()
                    } label: {
                        Text("Add Vehicle", comment: "Lets a user add a vehicle.")
                    }
                } header: {
                    Text("Vehicles", comment: "Displays vehicles to the user.")
                }
                
                Section {
                    NavigationLink {
                        AuthenticationView(viewModel: authenticationViewModel)
                    } label: {
                        Label {
                            Text("Profile", comment: "Lets the user access their profile.")
                        } icon: {
                            Image(systemName: "person")
                        }
                    }
                }
                
                Text("Version \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))", comment: "Displays displays version and build number.")
            }
            .alert(Text("Failed To Delete Vehicle", comment: "Displays title of the delete vehicle alert"),
                   isPresented: $showDeleteVehicleError) {
                Button {
                    showDeleteVehicleError = false
                } label: {
                    Text("OK", comment: "Lets the user perform a dismiss action")
                }
            } message: {
                if let errorDetails {
                    Text("Failed To Delete Vehicle\nDetails:\(errorDetails.localizedDescription)", comment: "Lets a user view delete vehicle error details.")
                } else {
                    Text("Failed To Add Vehicle. Unknown Error.", comment: "Lets a user view add vehicle error details.")
                }
            }
            .navigationTitle(Text("Settings", comment: "Displays settings to the user."))
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
