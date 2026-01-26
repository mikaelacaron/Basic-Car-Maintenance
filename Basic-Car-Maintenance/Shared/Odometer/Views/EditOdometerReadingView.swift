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
                            
                            if let vehicleName = vehicles
                                .filter({ $0.id == selectedReading.vehicleID }).first?.name {
                                Text(vehicleName)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .liquidGlassSection()
                        .accessibilityLabel("Selected vehicle")
                        .accessibilityValue(vehicles.first { $0.id == selectedReading.vehicleID }?.name ?? "None")
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
                setEditReadingValues(selectedReading)
            }
            .navigationTitle(Text("Edit Reading",
                                  comment: "Title for form when editing an odometer reading"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let reading = OdometerReading(id: selectedReading.id,
                                                      date: date,
                                                      distance: distance,
                                                      isMetric: isMetric,
                                                      vehicleID: selectedReading.vehicleID)
                        updateTapped(reading)
                        dismiss()
                    } label: {
                        Text("Update",
                             comment: "Label for submit button on form to update an existing entry")
                            .bold()
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
    EditOdometerReadingView(
        selectedReading: OdometerReading(date: Date(),
                                         distance: 0,
                                         isMetric: false,
                                         vehicleID: ""),
        vehicles: []) { _ in }
}
