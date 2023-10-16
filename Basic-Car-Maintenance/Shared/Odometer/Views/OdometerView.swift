//
//  OdometerView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 10/11/23.
//

import SwiftUI

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @Bindable private var viewModel: OdometerViewModel

    init(authenticationViewModel: AuthenticationViewModel) {
        viewModel = OdometerViewModel(authenticationViewModel: authenticationViewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.readings) { reading in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(reading.distance) \(reading.unitsAreMetric ? "Km" : "M")")
                            .font(.title3)
                        
                        Text("For \(reading.vehicle.name)")
                        
                        Text("\(reading.date.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
                .listStyle(.inset)
            }
            .overlay {
                if viewModel.readings.isEmpty {
                    Text("Add your first odometer")
                }
            }
            .navigationTitle(Text("Odometer"))
            .alert("Failed To Delete Reading", isPresented: $viewModel.showErrorAlert) {
                Button("OK") {
                    viewModel.showErrorAlert = false
                }
            } message: {
                Text(viewModel.errorMessage).padding()
            }
            .navigationDestination(isPresented: $viewModel.isShowingAddOdometerReading) {
                makeAddOdometerView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        viewModel.isShowingAddOdometerReading = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await viewModel.getOdometerReadings()
                await viewModel.getVehicles()
            }
            .sheet(isPresented: $viewModel.isShowingAddView) {
                makeAddOdometerView()
            }
        }
    }
    
    private func makeAddOdometerView() -> some View {
        AddOdometerReadingView(vehicles: viewModel.vehicles) { reading in
            viewModel.addReading(reading)
            Task {
                await viewModel.getOdometerReadings()
            }
        }
        .alert("An Error Occurred", isPresented: $viewModel.showAddErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    OdometerView(authenticationViewModel: AuthenticationViewModel())
        .environment(ActionService.shared)
}
