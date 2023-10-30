//
//  AddOdometerReadingView.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import SwiftUI

struct AddOdometerReadingView: View {
    
    let addTapped: (OdometerReading) -> Void
    
    @Environment(\.dismiss) var dismiss
    @Environment(AppSharedInfo.self) var sharedInfo
    
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
                        ForEach(sharedInfo.vehicles, id: \.self) { vehicle in
                            Text(vehicle.name)
                                .tag(vehicle.documentID)
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
                if let firstVehicle = sharedInfo.vehicles.first {
                    selectedVehicleID = firstVehicle.documentID
                }
            }
            .navigationTitle(Text("Add Reading",
                                  comment: "Title for form when adding an odometer reading"))
            .toolbar {
                ToolbarItem {
                    Button {
                        let selectedVehicle = sharedInfo.vehicles.first { $0.documentID == selectedVehicleID }
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
    }
}

#Preview {
    AddOdometerReadingView() { _ in }
}

let sampleVehicle = [
    Vehicle(name: "Nate Forester", make: "Subaru", model: "Forester"),
    Vehicle(name: "Dani Impreza", make: "Subaru", model: "Impreza")
]
