//
//  WelcomeViewAddVehicle.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
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
        ZStack {
            LinearGradient(
                colors: [
                    .darkBackground,
                    Color(red: 0.08, green: 0.08, blue: 0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color.accentGreen.opacity(0.05))
                .frame(width: 200)
                .blur(radius: 30)
                .offset(x: -150, y: -300)
            
            Circle()
                .fill(Color.blue.opacity(0.05))
                .frame(width: 300)
                .blur(radius: 40)
                .offset(x: 100, y: 400)
            
            VStack(spacing: 25) {
                VStack(spacing: 8) {
                    Text("Add the details below")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    HStack(spacing: 5) {
                        Text("about")
                            .foregroundStyle(.white)
                        Text("your vehicle")
                            .foregroundStyle(Color.accentGreen)
                    }
                    .font(.title2)
                }
                .multilineTextAlignment(.center)
                .padding(.vertical, 30)
                .padding(.horizontal, 25)
                .background(
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        Rectangle()
                            .fill(Color.glassTint)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 15, y: 8)
                .padding(.top, 65)
                .padding(.horizontal, 20)
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Circle()
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                .white.opacity(0.3),
                                                .white.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        Image(systemName: "car.side.lock.open")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.accentGreen)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    
                    VStack(spacing: 0) {
                        List {
                            Section {
                                glassFormField(
                                    title: "Name",
                                    placeholder: "Vehicle Name",
                                    text: $vehicleName
                                )
                                glassFormField(
                                    title: "Make",
                                    placeholder: "Vehicle Make",
                                    text: $vehicleMake
                                )
                                glassFormField(
                                    title: "Model",
                                    placeholder: "Vehicle Model",
                                    text: $vehicleModel
                                )
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.white.opacity(0.3))
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: 220)
                    }
                    .background(
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                            Rectangle()
                                .fill(Color.glassTint)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.25),
                                        .white.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                }
                .padding(.horizontal, 20)
                
                Text("You can edit more data about the vehicle in the 'Settings' tab.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer(minLength: 20)
                
                Button {
                    //                    isFirstTime = false
                } label: {
                    Text("Welcome 🥳")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            ZStack {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                
                                Rectangle()
                                    .fill(Color.accentGreen.opacity(0.4))
                                
                                LinearGradient(
                                    colors: [
                                        Color.accentGreen.opacity(0.3),
                                        Color.blue.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.accentGreen.opacity(0.6),
                                            Color.accentGreen.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: Color.accentGreen.opacity(0.3), radius: 15, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.circle.fill")
                        Text("Back")
                    }
                    .foregroundStyle(Color.accentGreen)
                    .font(.headline)
                }
            }
        }
    }
    
    @ViewBuilder
    private func glassFormField(title: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.white)
                .fontWeight(.medium)
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            TextField(placeholder, text: text)
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder)
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.trailing)
                }
        }
        .padding(.vertical, 8)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    WelcomeViewAddVehicle()
}
