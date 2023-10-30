//
//  AddMaintenanceView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import FirebaseAnalyticsSwift
import SwiftUI

struct AddMaintenanceView: View {
    let addTapped: (MaintenanceEvent) -> Void
    
    @State private var title = ""
    @State private var date = Date()
    @State private var selectedVehicleID: String?
    @State private var notes = ""
    @Environment(\.dismiss) var dismiss
    @Environment(AppSharedInfo.self) var sharedInfo
    
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
                    Picker(selection: $selectedVehicleID) {
                        ForEach(sharedInfo.vehicles, id: \.self) { vehicle in
                            Text(vehicle.name).tag(vehicle.documentID)
                        }
                    } label: {
                        Text("Select a vehicle",
                             comment: "Picker for selecting a vehicle")
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
            .analyticsScreen(name: "\(Self.self)")
            .navigationTitle(Text("Add Maintenance",
                                  comment: "Nagivation title for Add Maintenance view"))
            .toolbar {
                ToolbarItem {
                    Button {
                        
                        if let selectedVehicleID {
                            if let vehicle = sharedInfo.vehicles
                                .first(where: { $0.documentID == selectedVehicleID }) {
                                let event = MaintenanceEvent(
                                    title: title,
                                    date: date,
                                    notes: notes,
                                    vehicle: vehicle
                                )
                                addTapped(event)
                            }
                            dismiss()
                        }
                    } label: {
                        Text("Add",
                             comment: "Label for submit button on form to add an entry")
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddMaintenanceView() { _ in }
}

let sampleVehicles = [
    Vehicle(name: "Lexus", make: "Lexus", model: "White"),
    Vehicle(name: "Test", make: "Lexus", model: "White")
]
