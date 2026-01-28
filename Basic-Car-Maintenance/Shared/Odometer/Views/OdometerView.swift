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
        self.init(viewModel: OdometerViewModel(userUID: userUID))
    }
    
    fileprivate init(viewModel: OdometerViewModel) {
        self.viewModel = viewModel
    }
    
    // swiftlint:disable:next line_length
    /// Filter the readings based on the selected vehicle in the filter, and if no vehicle is selected, it shows all the vehicles' readings
    private var filteredReadings: [OdometerReading] {
        if viewModel.selectedVehicle == nil {
            return viewModel.readings
        } else {
            return viewModel.readings.filter { $0.vehicleID == viewModel.selectedVehicle?.id }
        }
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
                    .liquidGlassChart()
                }
                
                List {
                    ForEach(filteredReadings) { reading in
                        let vehicleName = viewModel.vehicles.first { $0.id == reading.vehicleID }?.name
                        OdometerRowView(reading: reading, vehicleName: vehicleName)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .liquidGlassCard()
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
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            }
            .overlay {
                if viewModel.readings.isEmpty {
                    ContentUnavailableView {
                        Label {
                            Text("Tap the + to begin",
                                 comment: "Empty odometer list prompt")
                        } icon: {
                            Image(systemName: SFSymbol.speedometer)
                        }
                    } description: {
                        Text("Add your first odometer",
                             comment: "Placeholder description for empty odometer reading list")
                    }
                }
            }
            .navigationTitle(Text("Odometer"))
            .navigationDestination(isPresented: $viewModel.isShowingAddOdometerReading) {
                makeAddOdometerView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Menu {
                        Button("All") {
                            viewModel.selectedVehicle = nil
                            applyFilter()
                        }
                        ForEach(viewModel.vehicles) { vehicle in
                            Button(vehicle.name) {
                                viewModel.selectedVehicle = vehicle
                                applyFilter()
                            }
                        }
                    } label: {
                        Image(systemName: SFSymbol.filter)
                    }
                    .accessibilityShowsLargeContentViewer {
                        Label {
                            Text("Filter.Odometer", comment: "Label for filtering on Odometer view")
                        } icon: {
                            Image(systemName: SFSymbol.filter)
                        }
                    }
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
    
    /// Checks if we have selected any vehicle for filtering the readings.
    private func applyFilter() {
        if let selectedVehicle = viewModel.selectedVehicle {
            viewModel.selectedVehicle = viewModel.vehicles.first(where: { $0.id == selectedVehicle.id })
        } else {
            viewModel.selectedVehicle = nil
        }
    }
    
    // swiftlint:disable:next line_length
    /// Filter the readings based on the selected time range, and if there are no readings in the last 30 days, just show the last reading.
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
    let viewModel = OdometerViewModel(userUID: nil)
    let firstCar = createVehicle(id: "id1", name: "My 1st car")
    let secondCar = createVehicle(id: "id2", name: "2nd Car")
    let thirdCar = createVehicle(id: "id3", name: "3rd Car")

    viewModel.vehicles.append(contentsOf: [firstCar, secondCar, thirdCar])
    
    let firstReading = createReading(vehicleID: firstCar.id!,
                                     date: "2024/10/18",
                                     distance: 35)
    let secondReading = createReading(vehicleID: firstCar.id!,
                                      date: "2024/10/19",
                                      distance: 564)
    let thirdReading = createReading(vehicleID: firstCar.id!,
                                      date: "2024/11/23",
                                      distance: 1000)
    
    let fourthReading = createReading(vehicleID: firstCar.id!,
                                     date: "2024/11/30",
                                     distance: 1024)
    let fifthReading = createReading(vehicleID: secondCar.id!,
                                      date: "2024/10/1",
                                      distance: 1000)
    
    let sixthReading = createReading(vehicleID: secondCar.id!,
                                     date: "2024/10/13",
                                     distance: 1144)
    let seventhReading = createReading(vehicleID: secondCar.id!,
                                      date: "2024/10/15",
                                      distance: 1412)
    
    let eighthReading = createReading(vehicleID: secondCar.id!,
                                     date: "2024/11/13",
                                     distance: 1542)
    
    let ninthReading = createReading(vehicleID: thirdCar.id!,
                                     date: "2024/11/16",
                                     distance: 1600)
    
    // swiftlint:disable:next line_length
    viewModel.readings.append(contentsOf: [firstReading, secondReading, thirdReading, fourthReading, fifthReading, sixthReading, seventhReading, eighthReading, ninthReading])
    
    return OdometerView(viewModel: viewModel)
        .environment(ActionService.shared)
    
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
}
