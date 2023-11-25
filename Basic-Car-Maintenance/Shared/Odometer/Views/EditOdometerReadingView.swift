//
//  EditOdometerReadingView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 11/25/23.
//

import SwiftUI

struct EditOdometerReadingView: View {
    let selectedReading: OdometerReading
    
    let vehicles: [Vehicle]
    let updateTapped: (OdometerReading) -> Void
    
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
                setEditReadingValues(selectedReading)
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
                            updateTapped(reading)
                        }
                    } label: {
                        Text("Update",
                             comment: "Label for submit button on form to add an entry")
                    }
                    .disabled(distance < 0)
                }
            }
        }
        .analyticsView("\(Self.self)")
    }
    
    func setEditReadingValues(_ reading: OdometerReading) {
        self.date = reading.date
        self.selectedVehicleID = reading.vehicleID
        self.isMetric = reading.isMetric
        self.distance = reading.distance
    }
}

#Preview {
    EditOdometerReadingView(
        selectedReading: OdometerReading(date: Date(),
                                         distance: 0,
                                         isMetric: false,
                                         vehicleID: ""),
        vehicles: []) { _ in }
}
