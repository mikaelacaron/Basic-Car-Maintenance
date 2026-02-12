//
//  EditOdometerReadingView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct EditOdometerReadingView: View {
    let selectedReading: OdometerReading
    
    let vehicles: [Vehicle]
    let updateTapped: (OdometerReading) -> Void
    
    @State private var date = Date()
    @State private var isMetric = false
    @State private var distance = 0
    
    @Environment(\.dismiss) private var dismiss
    
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
                        
                        if let vehicleName = vehicles
                            .filter({ $0.id == selectedReading.vehicleID }).first?.name {
                            Text(vehicleName)
                                .opacity(0.3)
                        }
                    }
                } header: {
                    Text("Vehicle")
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
                setEditReadingValues(selectedReading)
            }
            .navigationTitle(Text("Edit Reading",
                                  comment: "Title for form when editing an odometer reading"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem {
                    Button(role: .confirm) {
                        let reading = OdometerReading(id: selectedReading.id,
                                                      date: date,
                                                      distance: distance,
                                                      isMetric: isMetric,
                                                      vehicleID: selectedReading.vehicleID)
                        updateTapped(reading)
                    } label: {
                        Label("Update", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                    }
                    .disabled(distance < 0)
                }
            }
        }
        .analyticsView("\(Self.self)")
    }
    
    func setEditReadingValues(_ reading: OdometerReading) {
        self.date = reading.date
        self.isMetric = reading.isMetric
        self.distance = reading.distance
    }
}

#Preview {
    let sampleVehicles = [
        Vehicle(id: UUID().uuidString, name: "Nate Forester", make: "Subaru", model: "Forester"),
        Vehicle(id: UUID().uuidString, name: "Dani Impreza", make: "Subaru", model: "Impreza")
    ]
    
    EditOdometerReadingView(
        selectedReading: OdometerReading(date: Date(),
                                         distance: 0,
                                         isMetric: false,
                                         vehicleID: sampleVehicles[0].id!),
        vehicles: sampleVehicles) { _ in }
}
