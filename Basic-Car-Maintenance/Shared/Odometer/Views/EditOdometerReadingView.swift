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
    
    @Environment(\.dismiss) private var dismiss
    
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
                    if let vehicleName = vehicles
                        .filter({ $0.id == selectedReading.vehicleID }).first?.name {
                        Text(vehicleName)
                            .opacity(0.3)
                    }
                } header: {
                    Text("Vehicle")
                }
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date", comment: "Date picker label")
                }
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
            }
            .onAppear {
                setEditReadingValues(selectedReading)
            }
            .navigationTitle(Text("Edit Reading",
                                  comment: "Title for form when editing an odometer reading"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
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
