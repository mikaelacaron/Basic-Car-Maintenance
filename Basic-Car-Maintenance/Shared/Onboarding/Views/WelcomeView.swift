//
//  WelcomeView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct WelcomeView: View {
    var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                VStack {
                    HStack(spacing: 5) {
                        Text("Welcome to")
                        Text("Basic")
                            .foregroundStyle(.basicGreen)
                    }
                    Text("Car Maintenance")
                        .foregroundStyle(.basicGreen)
                }
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
                .padding(15)
                
                VStack(alignment: .leading, spacing: 25) {
                    pointView(
                        symbol: "car",
                        title: "Dashboard",
                        subtitle: "User-friendly interface for controlling car maintenance tasks."
                    )
                    
                    pointView(
                        symbol: "gauge.with.dots.needle.bottom.50percent.badge.plus",
                        title: "Odometer",
                        subtitle: "Tracks & displays total mileage, aiding timely maintenance planning."
                    )
                    
                    pointView(
                        symbol: "lock.open",
                        title: "Open Source",
                        subtitle: "Built collaboratively with contributors, enhancing the app functionality."
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(15)
                
                Spacer(minLength: 10)
                
                NavigationLink(
                    destination: WelcomeViewAddVehicle()) {
                    Text("Continue")
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
        }
    }
    
    @ViewBuilder
    // swiftlint:disable:next line_length
    func pointView(symbol: String, title: LocalizedStringResource, subtitle: LocalizedStringResource) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(.basicGreen)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    WelcomeView(authenticationViewModel: AuthenticationViewModel())
}
