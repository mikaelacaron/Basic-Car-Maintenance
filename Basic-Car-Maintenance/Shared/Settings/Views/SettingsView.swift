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
    @State private var showAddVehicleError = false
    @State var errorDetails: Error? = nil
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    init(authenticationViewModel: AuthenticationViewModel) {
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(authenticationViewModel: authenticationViewModel)) // swiftlint:disable:this line_length
        self.authenticationViewModel = authenticationViewModel
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
                
                Section {
                    ForEach(viewModel.vehicles) { vehicle in
                        VStack {
                            Text(vehicle.name)
                                .font(.headline)
                            
                            Text(vehicle.make)
                            
                            Text(vehicle.model)
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
                        AuthenticationView(viewModel: authenticationViewModel)
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
            .alert("Failed to add vehicle", isPresented: $showAddVehicleError, actions: {
                Button("Ok, got it!"){
                    showAddVehicleError = false
                }
            }, message: {
                if let errorDetails {
                    Text("Failed to add vehicle, internal error occured\nDetails:\(errorDetails.localizedDescription)")
                } else {
                    Text("Failed to add vehicle, internal error occured. Unknown error occured")
                }
            })
            .navigationTitle(Text("Settings"))
            .task {
                await viewModel.getVehicles()
            }
            .sheet(isPresented: $isShowingAddVehicle) {
                AddVehicleView() { vehicle in
                    Task {
                        await viewModel.addVehicle(vehicle) { result in
                            switch result {
                            case .success(_):
                                isShowingAddVehicle = false
                            case .failure(let error):
                                errorDetails = error
                                showAddVehicleError = true
                            }
                        }
                    }
                }
            }

        }
    }
}

#Preview {
    SettingsView(authenticationViewModel: AuthenticationViewModel())
}
