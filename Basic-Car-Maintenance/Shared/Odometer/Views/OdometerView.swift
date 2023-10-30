//
//  OdometerView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 10/11/23.
//

import FirebaseAnalyticsSwift
import SwiftUI

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    @Environment(AppSharedInfo.self) var sharedInfo
    
    @StateObject private var viewModel = OdometerViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.readings) { reading in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(reading.distance) \(reading.isMetric ? "km" : "mi")")
                            .font(.title3)
                        
                        Text("For \(reading.vehicle.name)")
                        
                        Text("\(reading.date.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
                .listStyle(.inset)
            }
            .overlay {
                if viewModel.readings.isEmpty {
                    Text("Add your first odometer",
                         comment: "Placeholder text for empty odometer reading list")
                }
            }
            .navigationTitle(Text("Odometer"))
            .navigationDestination(isPresented: $viewModel.isShowingAddOdometerReading) {
                makeAddOdometerView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        viewModel.isShowingAddOdometerReading = true
                    } label: {
                        Image(systemName: SFSymbol.plus)
                    }
                }
            }
            .task {
                await viewModel.getOdometerReadings()
            }
        }
        .analyticsScreen(name: "\(Self.self)")
    }
    
    private func makeAddOdometerView() -> some View {
        AddOdometerReadingView() { reading in
            do {
                try viewModel.addReading(reading)
                viewModel.isShowingAddOdometerReading = false
                Task {
                    await viewModel.getOdometerReadings()
                }
            } catch {
                viewModel.errorMessage = error.localizedDescription
                viewModel.showAddErrorAlert = true
            }
        }
        .alert("An Error Occurred", isPresented: $viewModel.showAddErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    OdometerView()
        .environment(ActionService.shared)
}
