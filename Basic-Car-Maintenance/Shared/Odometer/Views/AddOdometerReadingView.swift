//
//  AddOdometerReadingView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct AddOdometerReadingView: View {
    
    let vehicles: [Vehicle]
    let addTapped: (OdometerReading) -> Void
    
    @AppStorage(AppStorageKeys.measurementSystem) 
    private var defaultUnitSystem: MeasurementSystem = .userDefault
    
    @Environment(\.dismiss) var dismiss
    
    @State private var date = Date()
    @State private var selectedVehicleID: String?
    @State private var isMetric = false
    @State private var distance = 0
    
    init(
        vehicles: [Vehicle],
        addTapped: @escaping (OdometerReading) -> Void
    ) {
        self.vehicles = vehicles
        self.addTapped = addTapped
        self.isMetric = _defaultUnitSystem.wrappedValue == .metric
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: SFSymbol.gaugeWithNeedle)
                            .foregroundStyle(.secondary)
                        TextField("Distance", value: $distance, format: .number)
                        
                        Picker(selection: $isMetric) {
                            Text("Miles", comment: "Label for miles unit")
                                .tag(false)
                            Text("Kilometers", comment: "Label for kilometers unit")
                                .tag(true)
                        } label: {
                            Text("Preferred units",
                                 comment: "Label for units selected when adding an odometer reading")
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: SFSymbol.carFill)
                            .foregroundStyle(.secondary)
                        
                        Picker(selection: $selectedVehicleID) {
                            ForEach(vehicles) { vehicle in
                                Text(vehicle.name)
                                    .tag(vehicle.id)
                            }
                        } label: {
                            Text("Select a vehicle",
                                 comment: "Picker for selecting a vehicle")
                        }
                        .pickerStyle(.menu)
                    }
                } header: {
                    Text("VehicleSectionHeader",
                         comment: "Label for Picker for selecting a vehicle")
                }
                
                HStack {
                    Image(systemName: SFSymbol.calendar)
                        .foregroundStyle(.secondary)
                    
                    DatePicker(selection: $date, displayedComponents: .date) {
                        Text("Date", comment: "Date picker label")
                    }
                    .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                }
            }
            .onAppear {
                if !vehicles.isEmpty {
                    selectedVehicleID = vehicles[0].id
                }
            }
            .navigationTitle(Text("Add Reading",
                                  comment: "Title for form when adding an odometer reading"))
            .toolbar {
                ToolbarItem {
                    Button(role: .confirm) {
                        if let selectedVehicleID {
                            let reading = OdometerReading(date: date,
                                                          distance: distance,
                                                          isMetric: isMetric,
                                                          vehicleID: selectedVehicleID)
                            addTapped(reading)
                        }
                    } label: {
                        Label("Add", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                    }
                    .disabled(distance < 0)
                }
            }
        }
        .analyticsView("\(Self.self)")
    }
}

#Preview {
    let sampleVehicles = [
        Vehicle(name: "Nate Forester", make: "Subaru", model: "Forester"),
        Vehicle(name: "Dani Impreza", make: "Subaru", model: "Impreza")
    ]

    AddOdometerReadingView(vehicles: sampleVehicles) { _ in }
}
