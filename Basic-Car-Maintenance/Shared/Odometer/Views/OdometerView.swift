///
///  OdometerView.swift
///  Basic-Car-Maintenance
///
///  https://github.com/mikaelacaron/Basic-Car-Maintenance
///  See LICENSE for license information.
///

import SwiftUI
import Charts

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    
    @StateObject private var viewModel: OdometerViewModel
    @State private var selectedTimeRange: TimeRange = .all
    
    init(userUID: String?) {
        _viewModel = StateObject(wrappedValue: OdometerViewModel(userUID: userUID))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Time Range", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases) { timeRange in
                        Text(timeRange.rawValue).tag(timeRange)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if !viewModel.readings.isEmpty {
                    GroupBox {
                        Chart {
                            ForEach(viewModel.vehicles) { vehicle in
                                let vehicleReadings = filteredReadings(for: vehicle)
                                
                                if !vehicleReadings.isEmpty {
                                    ForEach(vehicleReadings) { reading in
                                        LineMark(
                                            x: .value("Date", reading.date, unit: .day),
                                            y: .value("Odometer", reading.distance)
                                        )
                                    }
                                    .foregroundStyle(by: .value("Vehicle", vehicle.name))
                                    .symbol(by: .value("Vehicle", vehicle.name))
                                    .interpolationMethod(.monotone)
                                }
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                }
                
                List {
                    ForEach(viewModel.readings) { reading in
                        let vehicleName = viewModel.vehicles.first { $0.id == reading.vehicleID }?.name
                        OdometerRowView(reading: reading, vehicleName: vehicleName)
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
                                    Label("Edit", systemImage: SFSymbol.pencil)
                                }
                            }
                    }
                    .listStyle(.inset)
                }
            }
            .overlay {
                if viewModel.readings.isEmpty {
                    Text("Add your first odometer")
                }
            }
            .navigationTitle("Odometer")
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
                    EditOdometerReadingView(selectedReading: selectedReading, vehicles: viewModel.vehicles) { updatedReading in
                        Task {
                            await viewModel.updateOdometerReading(updatedReading)
                        }
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
    
    private func filteredReadings(for vehicle: Vehicle) -> [OdometerReading] {
        let vehicleReadings = viewModel.readings.filter { $0.vehicleID == vehicle.id }
        
        switch selectedTimeRange {
        case .all:
            return vehicleReadings
        case .last30Days:
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            return vehicleReadings.filter { $0.date >= thirtyDaysAgo } + (vehicleReadings.max(by: { $0.date < $1.date }).map { [$0] } ?? [])
        }
    }
    
    private func makeAddOdometerView() -> some View {
        AddOdometerReadingView(vehicles: viewModel.vehicles) { reading in
            Task {
                do {
                    try await viewModel.addReading(reading)
                    viewModel.isShowingAddOdometerReading = false
                    await viewModel.getOdometerReadings()
                } catch {
                    viewModel.errorMessage = error.localizedDescription
                    viewModel.showAddErrorAlert = true
                }
            }
        }
        .alert("An Error Occurred", isPresented: $viewModel.showAddErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

/// The time range options in the picker for the graph.
enum TimeRange: String, CaseIterable, Identifiable {
    case all = "All readings"
    case last30Days = "Latest readings"
    
    var id: String { self.rawValue }
}

