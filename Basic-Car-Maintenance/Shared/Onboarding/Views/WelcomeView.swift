//
//  WelcomeView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct WelcomeView: View {
    @State private var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                VStack {
                    HStack(spacing: 5) {
                        Text("Welcome to")
                        Text("Basic")
                            .foregroundStyle(Color("basicGreen"))
                    }
                    Text("Car Maintenance")
                        .foregroundStyle(Color("basicGreen"))
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
                        subTitle: "User-friendly interface for controlling car maintenance tasks."
                    )
                    
                    pointView(
                        symbol: "gauge.with.dots.needle.bottom.50percent.badge.plus",
                        title: "Odometer",
                        subTitle: "Tracks & displays total mileage, aiding timely maintenance planning."
                    )
                    
                    pointView(
                        symbol: "lock.open",
                        title: "Open Source",
                        subTitle: "Built collaboratively with contributors, enhancing the app functionality."
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(15)
                
                Spacer(minLength: 10)
                
                NavigationLink(
                    destination: WelcomeViewAddVehicle(authenticationViewModel: authenticationViewModel)) {
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
    func pointView(symbol: String, title: LocalizedStringKey, subTitle: LocalizedStringKey) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color("basicGreen"))
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
