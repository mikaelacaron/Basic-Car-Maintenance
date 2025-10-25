//
//  WelcomeView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
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
                    .fill(Color.accentGreen.opacity(0.03))
                    .frame(width: 300)
                    .blur(radius: 20)
                    .offset(x: -100, y: -200)
                
                Circle()
                    .fill(Color.blue.opacity(0.03))
                    .frame(width: 400)
                    .blur(radius: 30)
                    .offset(x: 150, y: 300)
                
                VStack(spacing: 35) {
                    VStack(spacing: 8) {
                        Text("Welcome to")
                            .font(.largeTitle.weight(.light))
                            .foregroundStyle(.white)
                        Text("Basic Car Maintenance")
                            .font(.title2.bold())
                            .foregroundStyle(Color.accentGreen)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
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
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 30)
                    
                    VStack(spacing: 25) {
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
                            subTitle: "Built collaboratively with contributors, enhancing app functionality."
                        )
                    }
                    .padding(28)
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
                                        .white.opacity(0.25),
                                        .white.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.25), radius: 20, y: 8)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    NavigationLink(destination: WelcomeViewAddVehicle()) {
                        Text("Continue")
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
                    .padding(.bottom, 60)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    func pointView(symbol: String, title: LocalizedStringKey, subTitle: LocalizedStringKey) -> some View {
        HStack(alignment: .top, spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color.accentGreen.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: symbol)
                    .font(.title2)
                    .foregroundStyle(Color.accentGreen)
                    .frame(width: 44, height: 44)
            }
            .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WelcomeView()
}

private extension Color {
    static let accentGreen = Color(red: 0.22, green: 1.0, blue: 0.56)
    static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.1)
    static let glassTint = Color.white.opacity(0.1)
}
