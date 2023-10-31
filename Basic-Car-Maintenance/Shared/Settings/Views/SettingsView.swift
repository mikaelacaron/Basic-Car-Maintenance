//
//  SettingsView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import FirebaseAnalyticsSwift
import SwiftUI
import UniformTypeIdentifiers
import TipKit

struct SettingsView: View {
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
   
    @ScaledMetric(relativeTo: .largeTitle) var iconDimension = 20.0
    
    @State private var viewModel: SettingsViewModel
    @State private var isShowingAddVehicle = false
    @State private var showDeleteVehicleError = false
    @State private var showAddVehicleError = false
    @State private var errorDetails: Error?
    @State private var copiedAppVersion: Bool = false
    
    private let appVersion = "Version \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))"
    
    init(authenticationViewModel: AuthenticationViewModel) {
        let settingsViewModel = SettingsViewModel(authenticationViewModel: authenticationViewModel)
        _viewModel = .init(initialValue: settingsViewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // swiftlint:disable:next line_length
                    Text("Thanks for using this app! It's open source and anyone can contribute to it.", comment: "Thanks a user for using the app and tells the user they can contribute to the codebase")
                    
                    Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance")!) {
                        Label {
                            Text("GitHub Repo", comment: "Link to the Basic Car Maintenance GitHub repo.")
                        } icon: {
                            Image("github-logo")
                                .resizable()
                                .frame(width: iconDimension, height: iconDimension)
                        }
                    }
                    .popoverTip(ContributionTip(), arrowEdge: .bottom)
                    
                    Link(destination: URL(string: "https://github.com/mikaelacaron")!) {
                        Text("🦄 Mikaela Caron - Maintainer", comment: "Link to maintainer Github account.")
                    }
                    
                    // swiftlint:disable:next line_length
                    Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=feature+request&projects=&template=feature-request.md&title=FEATURE+-")!) {
                        Label {
                            Text("Request a New Feature", comment: "Link to request a new feature.")
                        } icon: {
                            Image(systemName: SFSymbol.document)
                                .resizable()
                                .frame(width: iconDimension, height: iconDimension)
                        }
                    }
                    // swiftlint:disable:next line_length
                    Link(destination: URL(string: "https://github.com/mikaelacaron/Basic-Car-Maintenance/issues/new?assignees=&labels=bug&projects=&template=bug-report.md&title=BUG+-")!) {
                        Label {
                            Text("Report a Bug", comment: "Link to report a bug")
                        } icon: {
                            Image(systemName: SFSymbol.ladybug)
                                .resizable()
                                .frame(width: iconDimension, height: iconDimension)
                        }
                    }
                    
                    NavigationLink {
                        ContributorsListView(viewModel: viewModel)
                    } label: {
                        HStack {
                            Image(systemName: SFSymbol.contributors)
                            Text("Contributors", comment: "Link to contributors list.")
                        }
                    }
                    .foregroundStyle(.blue)
                }
                
                Section {
                    ForEach(viewModel.vehicles) { vehicle in
                        VStack {
                            Text(vehicle.name)
                                .font(.headline)
                            
                            Text(vehicle.make)
                            
                            Text(vehicle.model)

                            Text(vehicle.year ?? "")

                            Text(vehicle.color ?? "")

                            Text(vehicle.vin ?? "")

                            Text(vehicle.licensePlateNumber ?? "")
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
                        isShowingAddVehicle = true
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
                            Image(systemName: SFSymbol.person)
                        }
                    }
                    
                    NavigationLink {
                        ChooseAppIconView(viewModel: ChooseAppIconViewModel())
                    } label: {
                        Label("Change App Icon", systemImage: SFSymbol.iPhoneWithApps)
                    }
                }
                
                if let privacyURL = viewModel.privacyURL, !privacyURL.absoluteString.isEmpty {
                    Link("Privacy Policy", destination: privacyURL)
                }
                
                Text(LocalizedStringKey(appVersion),
                     comment: "Label to display version and build number.")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onLongPressGesture {
                        let clipboard = UIPasteboard.general
                        clipboard.setValue(appVersion, forPasteboardType: UTType.plainText.identifier)
                        copiedAppVersion = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            copiedAppVersion = false
                        }
                    }
                    .overlay {
                        // A toast view to notify the user of version copy
                        Text("Copied!", comment: "Text to notify user that app version was copied")
                            .font(.callout)
                            .padding(8)
                            .foregroundStyle(colorScheme == .light ? .white : .black)
                            .background(colorScheme == .light ? .black : .white)
                            .clipShape(Capsule())
                            .opacity(copiedAppVersion ? 1 : 0)
                            .animation(.linear(duration: 0.2), value: copiedAppVersion)
                    }
            }
            .analyticsScreen(name: "\(Self.self)")
            .navigationDestination(isPresented: $isShowingAddVehicle) {
                AddVehicleView() { vehicle in
                    Task {
                        do {
                            try await viewModel.addVehicle(vehicle)
                            await viewModel.getVehicles()
                            isShowingAddVehicle = false
                        } catch {
                            errorDetails = error
                            showAddVehicleError = true
                        }
                    }
                }
                .alert("Failed To Add Vehicle", isPresented: $showAddVehicleError) {
                    Button("OK") {
                        showAddVehicleError = false
                    }
                } message: {
                    if let errorDetails {
                        Text("Failed To Add Vehicle\nDetails:\(errorDetails.localizedDescription)")
                    } else {
                        Text("Failed To Add Vehicle. Unknown Error.")
                    }
                }
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
                    Text("Failed To Delete Vehicle\nDetails:\(errorDetails.localizedDescription)",
                         comment: "Label to display localized error description.")
                } else {
                    Text("Failed To Delete Vehicle. Unknown Error.",
                         comment: "Label to display error details.")
                }
            }
            .navigationTitle(Text("Settings", comment: "Label to display settings."))
            .task {
                await viewModel.getVehicles()
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
        .environment(ActionService.shared)
}
