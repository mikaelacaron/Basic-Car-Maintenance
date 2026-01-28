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
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: SFSymbol.speedometer)
                                .foregroundStyle(.secondary)
                            TextField("Distance", value: $distance, format: .number)
                        }
                        
                        Picker(selection: $isMetric) {
                            Text("Miles", comment: "Label for miles unit").tag(false)
                            Text("Kilometers", comment: "Label for kilometers unit").tag(true)
                        } label: {
                            Text("Preferred units",
                                 comment: "Label for unit system picker")
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .liquidGlassSection()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("VehicleSectionHeader",
                             comment: "Label for Picker for selecting a vehicle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.leading, 8)
                        
                        HStack {
                            Image(systemName: SFSymbol.carFill)
                                .foregroundStyle(.secondary)
                            Picker(selection: $selectedVehicleID) {
                                ForEach(vehicles) { vehicle in
                                    Text(vehicle.name)
                                        .tag(vehicle.id as String?)
                                }
                            } label: {
                                Text("Select a vehicle",
                                     comment: "Picker for selecting a vehicle")
                            }
                            .pickerStyle(.menu)
                        }
                        .padding()
                        .liquidGlassSection()
                    }
                    
                    VStack {
                        DatePicker(selection: $date, displayedComponents: .date) {
                            Label {
                                Text("Date", comment: "Date picker label")
                            } icon: {
                                Image(systemName: SFSymbol.calendar)
                            }
                        }
                        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                    }
                    .padding()
                    .liquidGlassSection()
                }
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                if !vehicles.isEmpty {
                    selectedVehicleID = vehicles[0].id
                }
            }
            .navigationTitle(Text("Add Reading",
                                  comment: "Title for form when adding an odometer reading"))
            .toolbar {
                ToolbarItem {
                    Button {
                        if let selectedVehicleID {
                            let reading = OdometerReading(date: date,
                                                          distance: distance,
                                                          isMetric: isMetric,
                                                          vehicleID: selectedVehicleID)
                            addTapped(reading)
                        }
                    } label: {
                        Text("Add",
                             comment: "Label for submit button on form to add an entry")
                    }
                    .disabled(distance < 0)
                }
            }
        }
        .analyticsView("\(Self.self)")
    }
}

#Preview {
    AddOdometerReadingView(vehicles: sampleVehicles) { _ in }
}

let sampleVehicle = [
    Vehicle(name: "Nate Forester", make: "Subaru", model: "Forester"),
    Vehicle(name: "Dani Impreza", make: "Subaru", model: "Impreza")
]
