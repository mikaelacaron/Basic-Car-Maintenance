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
    @State private var selectedVehicle: Vehicle?
    @State private var notes = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(text: $title,
                              prompt: Text("The title of the event",
                                           comment: "Maintenance event title text field label placeholder")) {
                        Text("Title of the maintenance event",
                             comment: "Maintenance event title text field label")
                    }
                } header: {
                    Text("Title",
                         comment: "Maintenance event title text field header")
                }
                
                Section {
                    Picker(selection: $selectedVehicle) {
                        ForEach(vehicles) { vehicle in
                            Text(vehicle.name)
                        }
                    } label: {
                        Text("Select a vehicle",
                             comment: "Maintenance event vehicle picker label")
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Vehicle",
                         comment: "Maintenance event vehicle picker header")
                }
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date",
                         comment: "Date picker label")
                }
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                
                Section {
                    TextField(text: $notes,
                              prompt: Text("Additional Notes",
                                           comment: "Notes text field placeholder"),
                              axis: .vertical) {
                        Text("Notes",
                             comment: "Maintenance event notes text field label")
                    }
                } header: {
                    Text("Notes",
                         comment: "Notes text field header")
                }
            }
            .navigationTitle(Text("Add Maintenance",
                                  comment: "Nagivation title for Add Maintenance view"))
            .toolbar {
                ToolbarItem {
                    Button {
                        let event = MaintenanceEvent(title: title, date: date, notes: notes)
                        addTapped(event)
                        dismiss()
                    } label: {
                        Text("Add",
                             comment: "Label for button to add data")
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
    Vehicle(name: "Lexus", make: "Lexus", model: "White")
]
