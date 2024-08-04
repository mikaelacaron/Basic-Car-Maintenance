//
//  WelcomeViewAddVehicle.swift
//  Basic-Car-Maintenance
//
//  Created by Marcin Jędrzejak on 09/01/2024.
//

import SwiftUI

struct WelcomeViewAddVehicle: View {
    
    // Logic to remember OnboardingScreen to not load again when app is launched
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("vehicleName") private var vehicleName: String = ""
    @AppStorage("vehicleMake") private var vehicleMake: String = ""
    @AppStorage("vehicleModel") private var vehicleModel: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var validationAlertName: Bool = false
    @State private var validationAlertMake: Bool = false
    @State private var validationAlertModel: Bool = false
    @State private var onboardingViewCompletedAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            VStack {
                headerView
                vehicleDetailsView
                bottomText
                Spacer(minLength: 10)
                addVehicleButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar { backButton }
    }
    
    private var headerView: some View {
        VStack {
            Text("Add the details below")
            HStack(spacing: 5) {
                Text("about")
                Text("your vehicle")
                    .foregroundStyle(Color("basicGreen"))
            }
        }
        .font(.largeTitle.bold())
        .multilineTextAlignment(.center)
        .padding(.top, 65)
        .padding(.bottom, 15)
    }
    
    private var vehicleDetailsView: some View {
        VStack {
            Image(systemName: "car.side.lock.open")
                .font(.system(size: 45))
                .foregroundStyle(Color("basicGreen"))
            
            List {
                vehicleDetailRow(title: "Name", text: $vehicleName, alert: $validationAlertName)
                vehicleDetailRow(title: "Make", text: $vehicleMake, alert: $validationAlertMake)
                vehicleDetailRow(title: "Model", text: $vehicleModel, alert: $validationAlertModel)
            }
            .frame(maxHeight: 200)
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 15)
    }
    
    private func vehicleDetailRow(title: String, text: Binding<String>, alert: Binding<Bool>) -> some View {
        LabeledContent {
            TextField("Vehicle \(title)", text: text)
                .alert(
                    "Vehicle \(title) cannot be empty! 🚗",
                    isPresented: alert
                ) {
                    Button("OK", role: .cancel) {}
                }
                .frame(width: 200)
        } label: {
            HStack {
                Text(title)
                Spacer()
            }
        }
        .showClearButton(text)
    }
    
    private var bottomText: some View {
        Text("You can edit more data about the vehicle in the 'Settings' tab.")
            .foregroundStyle(.gray)
            .padding(.horizontal, 25)
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
                .background(Color("basicGreen").gradient, in: .rect(cornerRadius: 12))
                .contentShape(.rect)
        }
        .padding(15)
        .padding(.horizontal, 15)
        .alert(
            Text("Congratulations! 🎉 🚙"),
            isPresented: $onboardingViewCompletedAlert
        ) {
            Button("OK", role: .cancel, action: {
                isFirstTime = false
            })
        } message: {
            Text(
                "From now on, next screen will be the main app screen.",
                comment: "Shows popup when completed Onboarding tutorial"
            )
        }
    }
    
    func addVehicle() {
        if vehicleName.isEmpty {
            validationAlertName = true
        } else if vehicleMake.isEmpty {
            validationAlertMake = true
        } else if vehicleModel.isEmpty {
            validationAlertModel = true
        } else {
            UserDefaults.standard.set(vehicleName, forKey: "vehicleName")
            UserDefaults.standard.set(vehicleMake, forKey: "vehicleMake")
            UserDefaults.standard.set(vehicleModel, forKey: "vehicleModel")
            
//            isFirstTime = false
            onboardingViewCompletedAlert = true
        }
    }
    
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left.circle")
                    Text("Back")
                }
                .tint(Color("basicGreen"))
            }
        }
    }
}

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if !text.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .imageScale(.medium)
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(text: text))
    }
}

#Preview {
    WelcomeViewAddVehicle()
}
