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
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reading Details")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "speedometer")
                                    .foregroundStyle(.secondary)
                                TextField("Distance", value: $distance, format: .number)
                                    .keyboardType(.numberPad)
                            }
                            
                            Divider()
                            
                            Picker(selection: $isMetric) {
                                Text("Miles").tag(false)
                                Text("Kilometers").tag(true)
                            } label: {
                                Text("Preferred units")
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .liquidGlassSection()
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Current mileage")
                        .accessibilityValue("\(distance) \(isMetric ? "kilometers" : "miles")")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vehicle")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                        
                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundStyle(.secondary)
                            Picker(selection: $selectedVehicleID) {
                                ForEach(vehicles) { vehicle in
                                    Text(vehicle.name)
                                        .tag(vehicle.id as String?)
                                }
                            } label: {
                                Text("Select a vehicle")
                            }
                            .pickerStyle(.menu)
                        }
                        .padding()
                        .liquidGlassSection()
                        .accessibilityLabel("Selected vehicle")
                        .accessibilityValue(vehicles.first { $0.id == selectedVehicleID }?.name ?? "None")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Date")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                        
                        DatePicker(selection: $date, displayedComponents: .date) {
                            Label("Date", systemImage: "calendar")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .liquidGlassSection()
                        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                        .accessibilityLabel("Recording date")
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                if !vehicles.isEmpty && selectedVehicleID == nil {
                    selectedVehicleID = vehicles[0].id
                }
            }
            .navigationTitle(Text("Add Reading",
                                  comment: "Title for form when adding an odometer reading"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
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
                            .bold()
                    }
                    .disabled(distance < 0)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
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
