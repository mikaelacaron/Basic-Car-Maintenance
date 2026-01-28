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
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: SFSymbol.speedometer)
                                .foregroundStyle(.secondary)
                            TextField("Distance", value: $distance, format: .number)
                        }
                        
                        Picker(selection: $isMetric) {
                            Text("Miles", comment: "Label for miles unit").tag(false)
                            Text("Kilometers", comment: "Label for kilometers unit").tag(true)
                        } label: {
                            Text("Preferred units",
                                 comment: "Label for unit system picker")
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .liquidGlassSection()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vehicle", comment: "Label for vehicle selection")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.leading, 8)
                        
                        HStack {
                            Image(systemName: SFSymbol.carFill)
                                .foregroundStyle(.secondary)
                            if let vehicleName = vehicles
                                .filter({ $0.id == selectedReading.vehicleID }).first?.name {
                                Text(vehicleName)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .liquidGlassSection()
                    }
                    
                    VStack {
                        DatePicker(selection: $date, displayedComponents: .date) {
                            Label {
                                Text("Date", comment: "Date picker label")
                            } icon: {
                                Image(systemName: SFSymbol.calendar)
                            }
                        }
                        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                    }
                    .padding()
                    .liquidGlassSection()
                }
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
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
                        let reading = OdometerReading(id: selectedReading.id,
                                                      date: date,
                                                      distance: distance,
                                                      isMetric: isMetric,
                                                      vehicleID: selectedReading.vehicleID)
                        updateTapped(reading)
                    } label: {
                        Text("Update",
                             comment: "Label for submit button on form to update an existing entry")
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
