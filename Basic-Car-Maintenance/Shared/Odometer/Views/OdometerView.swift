//
//  OdometerView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI
import Charts

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    
    @State private var viewModel: OdometerViewModel
    @State private var selectedTimeRange: TimeRange = .all
    
    init(userUID: String?) {
        self.init(viewModel: OdometerViewModel(userUID: userUID, firebaseService: FirebaseService.shared))
    }
    
    fileprivate init(viewModel: OdometerViewModel) {
        self.viewModel = viewModel
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
    
    // swiftlint:disable:next line_length
    /// Filter the readins based on the selected time range, and if there are no readings in the last 30 days, just show the last reading.
    /// - Parameter vehicle: The vehicle for these readings.
    /// - Returns: The `[OdometerReading]`s for this vehicle in the time range.
    private func filteredReadings(for vehicle: Vehicle) -> [OdometerReading] {
        let vehicleReadings = viewModel.readings.filter { $0.vehicleID == vehicle.id }
        
        switch selectedTimeRange {
        case .all:
            return vehicleReadings
        case .last30Days:
            guard let lastReadingDate = vehicleReadings.map({ $0.date }).max() else {
                return []
            }
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            
            // If the last reading is older than 30 days, include only the last reading
            if lastReadingDate < thirtyDaysAgo {
                if let lastReading = vehicleReadings.max(by: { $0.date < $1.date }) {
                    return [lastReading]
                } else {
                    return []
                }
            } else {
                return vehicleReadings.filter { $0.date >= thirtyDaysAgo }
            }
        }
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

/// The time range options in the picker for the graph.
enum TimeRange: String, CaseIterable, Identifiable {
    case all = "All readings"
    case last30Days = "Latest readings"
    
    var id: String { self.rawValue }
}

#Preview {
    let viewModel = createMockViewModel()
    OdometerView(viewModel: viewModel)
        .environment(ActionService.shared)
}

func createMockViewModel() -> OdometerViewModel {
    let viewModel = OdometerViewModel(userUID: nil, firebaseService: FirebaseService.shared)
    
    let firstCar = createVehicle(id: "id1", name: "My 1st car")
    let secondCar = createVehicle(id: "id2", name: "2nd Car")
    
    viewModel.vehicles.append(contentsOf: [firstCar, secondCar])
    
    let readings = [
        createReading(vehicleID: firstCar.id!, date: "2024/10/18", distance: 35),
        createReading(vehicleID: firstCar.id!, date: "2024/10/19", distance: 564),
        createReading(vehicleID: firstCar.id!, date: "2024/11/23", distance: 1000),
        createReading(vehicleID: firstCar.id!, date: "2024/11/30", distance: 1024),
        createReading(vehicleID: secondCar.id!, date: "2024/10/1", distance: 1000),
        createReading(vehicleID: secondCar.id!, date: "2024/10/13", distance: 1144),
        createReading(vehicleID: secondCar.id!, date: "2024/10/15", distance: 1412),
        createReading(vehicleID: secondCar.id!, date: "2024/11/13", distance: 1542)
    ]
    
    viewModel.readings.append(contentsOf: readings)
    
    return viewModel
}

func createVehicle(id: String, name: String) -> Vehicle {
    Vehicle(id: id, 
            userID: nil, 
            name: name, 
            make: "", 
            model: "", 
            year: nil, 
            color: nil, 
            vin: nil, 
            licensePlateNumber: nil)
}

func createReading(vehicleID: String, date: String, distance: Int) -> OdometerReading {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let firstDate = formatter.date(from: date)!
    return OdometerReading(id: UUID().uuidString,
                           userID: "", 
                           date: firstDate, 
                           distance: distance, 
                           isMetric: false, 
                           vehicleID: vehicleID)
}
