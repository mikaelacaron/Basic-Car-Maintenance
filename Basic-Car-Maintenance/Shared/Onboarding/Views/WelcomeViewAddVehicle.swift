//
//  WelcomeViewAddVehicle.swift
//  Basic-Car-Maintenance
//
//  Created by Marcin Jędrzejak on 09/01/2024.
//

import SwiftUI

struct WelcomeViewAddVehicle: View {
    
    // Logic to remember Onboarding screen to not load again when app is launched
//    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @Environment(\.dismiss) var dismiss
    
    @State private var vehicleName: String = ""
    @State private var vehicleMake: String = ""
    @State private var vehicleModel: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
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
            
            VStack {
                Image(systemName: "car.side.lock.open")
                    .font(.system(size: 45))
                    .foregroundStyle(Color("basicGreen"))
                
                List {
                    HStack {
                        Text("Name")
                        Spacer()
                            .frame(width: 40)
                        TextField("Vehicle Name", text: $vehicleName)
                    }
                    
                    HStack {
                        Text("Make")
                        Spacer()
                            .frame(width: 45)
                        TextField("Vehicle Make", text: $vehicleMake)
                    }
                    HStack {
                        Text("Model")
                        Spacer()
                            .frame(width: 40)
                        TextField("Vehicle Model", text: $vehicleModel)
                    }
                }
                .frame(maxHeight: 200)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            Text("You can edit more data about the vehicle in the 'Settings' tab.")
                .foregroundStyle(.gray)
                .padding(.horizontal, 25)
            
            Spacer(minLength: 10)
            
            Button {
//                isFirstTime = false
            } label: {
                Text("Welcome 🥳")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color("basicGreen").gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            }
            .padding(15)
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
}

#Preview {
    WelcomeViewAddVehicle()
}
