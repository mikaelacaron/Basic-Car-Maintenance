//
//  SettingsView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI
import UniformTypeIdentifiers
import TipKit
import StoreKit  // ✅ Added for App Store rating

struct SettingsView: View {
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @ScaledMetric(relativeTo: .largeTitle) var iconDimension = 20.0
    
    @AppStorage(AppStorageKeys.measurementSystem) private var defaultUnitSystem: MeasurementSystem = .userDefault
    
    @State private var viewModel: SettingsViewModel
    @State private var isShowingAddVehicle = false
    @State private var showDeleteVehicleError = false
    @State private var showDeleteVehicleAlert = false
    @State private var showAddVehicleError = false
    @State private var errorDetails: Error?
    @State private var copiedAppVersion: Bool = false
    
    @State private var selectedVehicle: Vehicle?
    @State private var isShowingEditVehicleView = false
    @State private var isShowingVehicleDetailView = false
    
    private let appVersion = "Version \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))"
    
    init(authenticationViewModel: AuthenticationViewModel) {
        let settingsViewModel = SettingsViewModel(authenticationViewModel: authenticationViewModel)
        _viewModel = .init(initialValue: settingsViewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Thanks for using this app! It's open source and anyone can contribute to it.")
                    
                    Link(destination: GitHubURL.repo) {
                        Label {
                            Text("GitHub Repo")
                        } icon: {
                            Image("github-logo")
                                .resizable()
                                .frame(width: iconDimension, height: iconDimension)
                        }
                    }
                    
                    Link(destination: GitHubURL.mikaelaCaronProfile) {
                        Text("🦄 Mikaela Caron - Maintainer")
                    }
                    
                    Link(destination: GitHubURL.featureRequest) {
                        Label {
                            Text("Request a New Feature")
                        } icon: {
                            Image(systemName: SFSymbol.document)
                                .resizable()
                                .frame(width: iconDimension, height: iconDimension)
                        }
                    }
                    
                    Link(destination: GitHubURL.bugReport) {
                        Label {
                            Text("Report a Bug")
                        } icon: {
                            Image(systemName: SFSymbol.ladybug)
                                .resizable()
                                .frame(width: iconDimension, height: iconDimension)
                        }
                    }
                    
                    // ✅ New "Rate the App" Button
                    Button(action: rateApp) {
                        Label {
                            Text("Rate the App") 
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    NavigationLink {
                        ContributorsListView(viewModel: viewModel)
                    } label: {
                        HStack {
                            Image(systemName: SFSymbol.contributors)
                            Text("Contributors")
                        }
                    }
                    .foregroundStyle(.blue)
                }
                
                Section {
                    ForEach(viewModel.vehicles) { vehicle in
                        Button {
                            selectedVehicle = vehicle
                            isShowingVehicleDetailView = true
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(vehicle.name)")
                                    .fontWeight(.bold)
                                    .font(.headline)
                                
                                Group {
                                    HStack {
                                        if let year = vehicle.year, !year.isEmpty {
                                            Text(year)
                                        }
                                        
                                        Text(vehicle.make)
                                        Text(vehicle.model)
                                    }
                                    
                                    if let licensePlateNumber = vehicle.licensePlateNumber, !licensePlateNumber.isEmpty {
                                        Text("Plate: \(licensePlateNumber)")
                                    }
                                    
                                    if let vin = vehicle.vin, !vin.isEmpty {
                                        Text("VIN: \(vin)")
                                    }
                                    
                                    if let color = vehicle.color, !color.isEmpty {
                                        Text("Color: \(color)")
                                    } 
                                }
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    do {
                                        if viewModel.vehicles.count > 1 {
                                            try await viewModel.deleteVehicle(vehicle)
                                        } else {
                                            showDeleteVehicleAlert = true
                                        }
                                    } catch {
                                        errorDetails = error
                                        showDeleteVehicleError = true
                                    }
                                }
                            } label: {
                                Text("Delete")
                            }
                            
                            Button {
                                selectedVehicle = vehicle
                                isShowingEditVehicleView = true
                            } label: {
                                Label {
                                    Text("Edit")
                                } icon: {
                                    Image(systemName: SFSymbol.pencil)
                                }
                            }
                        }
                    }
                
                    Button {
                        isShowingAddVehicle = true
                    } label: {
                        Text("Add Vehicle")
                    }
                } header: {
                    Text("Vehicles")
                }
                
                Section {
                    Picker("Preferred System", selection: $defaultUnitSystem) { 
                        ForEach(MeasurementSystem.allCases) { unit in
                            Text(unit.title)
                                .tag(unit)
                        }
                    }
                    .foregroundStyle(.blue)
                } header: {
                    Text("Units")
                }
                
                Section {
                    NavigationLink {
                        AuthenticationView(viewModel: viewModel.authenticationViewModel)
                    } label: {
                        Label {
                            Text("Profile")
                        } icon: {
                            Image(systemName: SFSymbol.person)
                        }
                    }
                    
                    NavigationLink {
                        ChooseAppIconView()
                    } label: {
                        Label("Change App Icon", systemImage: SFSymbol.iPhoneWithApps)
                    }
                }
                
                Link("Privacy Policy", destination: GitHubURL.privacy)
                
                Text(LocalizedStringKey(appVersion))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Settings")
        }
    }
    
    // ✅ Function to Open App Store Rating Popup
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

#Preview {
    SettingsView(authenticationViewModel: AuthenticationViewModel())
        .environment(ActionService.shared)
}
