//
//  WelcomeViewAddVehicle.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct WelcomeViewAddVehicle: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var vehicleName: String = ""
    @State private var vehicleMake: String = ""
    @State private var vehicleModel: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertType: AlertType?

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                headerView
                
                vehicleDetailsView
                
                Text("You can edit more data about the vehicle in the 'Settings' tab.")
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 25)
                
                Spacer(minLength: 10)
                
                addVehicleButton
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertType?.title ?? ""),
                message: Text(alertType?.message ?? ""),
                dismissButton: .default(Text("OK")) {
                    if case .vehicleAdded = alertType {
                        isFirstTime = false
                        dismiss()
                    }
                }
            )
        }
    }
    
    private var headerView: some View {
        VStack {
            Text("Add the details below about ") +
            Text("your vehicle")
                .foregroundStyle(Color("basicGreen"))
        }
        .font(.largeTitle)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.top, 65)
        .padding(.bottom, 15)
    }
    
    private var vehicleDetailsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.side.lock.open")
                .font(.system(size: 45))
                .foregroundStyle(.basicGreen)
            
            VStack(spacing: 0) {
                vehicleDetailRow(title: "Name", text: $vehicleName)
                    .padding(.bottom, 10)
                Divider()
                vehicleDetailRow(title: "Make", text: $vehicleMake)
                    .padding(.vertical, 10)
                Divider()
                vehicleDetailRow(title: "Model", text: $vehicleModel)
                    .padding(.top, 10)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
        }
        .padding(.horizontal, 15)
    }
    
    private func vehicleDetailRow(title: String, text: Binding<String>) -> some View {
        LabeledContent {
            TextField("Vehicle \(title)", text: text)
                .frame(width: 200)
        } label: {
            Text(title)
        }
        .showClearButton(text)
    }
    
    private var addVehicleButton: some View {
        Button {
            addVehicle()
        } label: {
            Text("Add Vehicle")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.basicGreen.gradient, in: .rect(cornerRadius: 12))
                .contentShape(.rect)
        }
        .padding(15)
        .padding(.horizontal, 15)
    }
    
    private func addVehicle() {
        if vehicleName.isEmpty {
            alertType = .emptyName
            showAlert = true
        } else if vehicleMake.isEmpty {
            alertType = .emptyMake
            showAlert = true
        } else if vehicleModel.isEmpty {
            alertType = .emptyModel
            showAlert = true
        } else {
            
            let newVehicle = Vehicle(name: vehicleName, make: vehicleMake, model: vehicleModel)
            
            Task {
                do {
                    // add new vehicle here
                    
                    alertType = .vehicleAdded(name: vehicleName)
                    showAlert = true
                } catch {
                    alertType = .error(message: "Failed to add vehicle. Please try again.")
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    WelcomeViewAddVehicle()
        .environment(ActionService.shared)
}

extension WelcomeViewAddVehicle {
    /// Types of alerts to be shown on the `WelcomeViewAddVehicle`
    enum AlertType {
        case emptyName
        case emptyMake
        case emptyModel
        case vehicleAdded(name: String)
        case error(message: String)
        
        var title: LocalizedStringResource {
            switch self {
            case .emptyName, .emptyMake, .emptyModel:
                return "Validation Error"
            case .vehicleAdded(let name):
                return "\(name) added successfully! 🎉"
            case .error:
                return "Error"
            }
        }
        
        var message: LocalizedStringResource? {
            switch self {
            case .emptyName:
                return "Vehicle Name cannot be empty! 🚗"
            case .emptyMake:
                return "Vehicle Make cannot be empty! 🚗"
            case .emptyModel:
                return "Vehicle Model cannot be empty! 🚗"
            case .vehicleAdded:
                return nil
            case .error(let message):
                return LocalizedStringResource(stringLiteral: message)
            }
        }
    }
}
