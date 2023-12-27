//
//  AddMaintenanceView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct AddMaintenanceView: View {
    
    let vehicles: [Vehicle]
    let addTapped: (MaintenanceEvent) -> Void
    
    @State private var title = ""
    @State private var date = Date()
    @State private var selectedVehicleID: String?
    @State private var notes = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        text: $title,
                        prompt: Text(
                            "The title of the event",
                            comment: "Maintenance event title text field label placeholder"
                        )
                        .accessibilityLabel("The title of the event.")
                    ) {
                        Text("Title of the maintenance event",
                             comment: "Maintenance event title text field label")
                        .accessibilityLabel("Title of the maintenance event.")
                    }
                } header: {
                    Text("Title",
                         comment: "Maintenance event title text field header")
                    .accessibilityLabel("Title")
                }
                
                Section {
                    Picker(selection: $selectedVehicleID) {
                        ForEach(vehicles) { vehicle in
                            Text(vehicle.name)
                                .tag(vehicle.id)
                                .accessibilityLabel(vehicle.name)
                        }
                    } label: {
                        Text("Select a vehicle",
                             comment: "Picker for selecting a vehicle")
                        .accessibilityLabel("Select a vehicle.")
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Vehicle",
                         comment: "Maintenance event vehicle picker header")
                    .accessibilityLabel("Vehicle.")
                }
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date",
                         comment: "Date picker label")
                    .accessibilityLabel("Date.")
                }
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                
                Section {
                    TextField(text: $notes,
                              prompt: Text("Additional Notes",
                                           comment: "Notes text field placeholder")
                                .accessibilityLabel("Additional Notes."),
                              axis: .vertical) {
                        Text("Notes",
                             comment: "Maintenance event notes text field label")
                        .accessibilityLabel("Notes.")
                    }
                } header: {
                    Text("Notes",
                         comment: "Notes text field header")
                    .accessibilityLabel("Notes.")
                }
            }
            .analyticsView("\(Self.self)")
            .navigationTitle(Text("Add Maintenance",
                                  comment: "Nagivation title for Add Maintenance view")
                .accessibilityLabel("Add maintenance."))
            .onAppear {
                if !vehicles.isEmpty {
                    selectedVehicleID = vehicles[0].id
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        if let selectedVehicleID {
                            let event = MaintenanceEvent(vehicleID: selectedVehicleID,
                                                         title: title,
                                                         date: date,
                                                         notes: notes)
                            addTapped(event)
                            dismiss()
                        }
                    } label: {
                        Text("Add",
                             comment: "Label for submit button on form to add an entry")
                        .accessibilityLabel("Add.")
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddMaintenanceView(vehicles: sampleVehicles) { _ in }
}

let sampleVehicles = [
    Vehicle(name: "Lexus", make: "Lexus", model: "White"),
    Vehicle(name: "Test", make: "Lexus", model: "White")
]
