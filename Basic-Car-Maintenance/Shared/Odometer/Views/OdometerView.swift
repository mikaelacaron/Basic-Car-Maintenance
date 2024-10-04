//
//  OdometerView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    
    @State private var viewModel: OdometerViewModel

    init(userUID: String?) {
        viewModel = OdometerViewModel(userUID: userUID)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.readings) { reading in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(reading.distance) \(reading.isMetric ? "km" : "mi")")
                            .font(.title3)
                        
                        let vehicleName = viewModel.vehicles.first { $0.id == reading.vehicleID }?.name
                        if let vehicleName {
                            Text("For \(vehicleName)")
                        }
                        
                        Text("\(reading.date.formatted(date: .abbreviated, time: .omitted))")
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteReading(reading)
                            }
                        } label: {
                            Image(systemName: SFSymbol.trash)
                        }
                        
                        Button {
                            viewModel.selectedReading = reading
                            viewModel.isShowingEditReadingView = true
                        } label: {
                            Label {
                                Text("Edit")
                            } icon: {
                                Image(systemName: SFSymbol.pencil)
                            }
                        }
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
                await viewModel.getVehicles()
            }
            .sheet(isPresented: $viewModel.isShowingEditReadingView) {
                if let selectedReading = viewModel.selectedReading {
                    // swiftlint:disable:next line_length
                    EditOdometerReadingView(selectedReading: selectedReading, vehicles: viewModel.vehicles) { updatedReading in
                        viewModel.updateOdometerReading(updatedReading)
                    }
                    .alert("An Error Occurred", isPresented: $viewModel.showEditErrorAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(viewModel.errorMessage)
                    }
                }
            }

        }
        .analyticsView("\(Self.self)")
    }
    
    private func makeAddOdometerView() -> some View {
        AddOdometerReadingView(vehicles: viewModel.vehicles) { reading in
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
    OdometerView(userUID: "")
        .environment(ActionService.shared)
}
