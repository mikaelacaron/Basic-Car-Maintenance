//
//  AddOdometerReadingView.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import SwiftUI

struct AddOdometerReadingView: View {
    
    let vehicles: [Vehicle]
    let addTapped: (OdometerReading) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var date = Date()
    @State private var selectedVehicleID: String?
    @State private var isMetric = false
    @State private var distance = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        TextField("Distance", value: $distance, format: .number)
                        
                        Picker(selection: $isMetric) {
                            Text("Miles").tag(false)
                            Text("Kilometers").tag(true)
                        } label: {
                            Text("Preferred units",
                                 comment: "Label for units selected when adding an odometer reading")
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section {
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
                } header: {
                    Text("VehicleSectionHeader",
                         comment: "Label for Picker for selecting a vehicle")
                }
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date", comment: "Date picker label")
                }
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
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
                    Button {
                        let selectedVehicle = vehicles.first { $0.id == selectedVehicleID }
                        if let selectedVehicle {
                            let reading = OdometerReading(date: date,
                                                          distance: distance,
                                                          isMetric: isMetric,
                                                          vehicle: selectedVehicle)
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
