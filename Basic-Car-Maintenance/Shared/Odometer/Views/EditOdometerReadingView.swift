//
//  EditOdometerReadingView.swift
//  Basic-Car-Maintenance
//
//  Created by Shakhnoza Mirabzalova on 10/26/23.
//

import FirebaseAnalyticsSwift
import SwiftUI

struct EditOdometerReadingView: View {
    
    @Binding var selectedOdometerReading: OdometerReading?
    var viewModel: OdometerViewModel
    @State private var date = Date()
    @State private var selectedVehicle: Vehicle?
    @State private var isMetric = false
    @State private var distance = 0
    @Environment(\.dismiss) var dismiss
    
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
                            Text("Preferred units", comment: "Label for units selected when adding an odometer reading")
                        }
                        .pickerStyle(.segmented)
                    }
                }
                        Section {
                            Picker(selection: $selectedVehicle) {
                                ForEach(viewModel.vehicles) { vehicle in
                                    Text(vehicle.name).tag(vehicle as Vehicle)
                                }
                            } label: {
                                Text("Select a vehicle", comment: "Picker for selecting a vehicle")
                            }
                            .pickerStyle(.menu)
                        } header: {
                            Text("Vehicle",
                                 comment: "Odometer reading vehicle picker header")
                        }
                        DatePicker(selection: $date, displayedComponents: .date) {
                            Text("Date")
                        }
            }
            .analyticsScreen(name: "\(Self.self)")
            .onAppear {
                // MARK: need to add appear
                guard let selectedOdometerReading = selectedOdometerReading else { return }
                setOdometerReadingValues(reading: selectedOdometerReading)
            }
            .navigationTitle(Text("Update Odometer"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // MARK: Need to add update action
                        if let selectedVehicle, let selectedOdometerReading {
                            var reading = OdometerReading(date: date, distance: distance, isMetric: isMetric, vehicle: selectedVehicle)
                            reading.id = selectedOdometerReading.id
                            Task {
                                // MARK: need to add update to viewmodel
                                await viewModel.updateReading(reading)
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Update")
                    }
                }
            }

        }
    }
    
    func setOdometerReadingValues(reading: OdometerReading) {
        self.distance = reading.distance
        self.date = reading.date
        self.isMetric = reading.isMetric
        self.selectedVehicle = reading.vehicle
    }
}

#Preview {
    EditOdometerReadingView(selectedOdometerReading: .constant(OdometerReading(date: Date(), distance: 0, isMetric: false, vehicle: Vehicle(name: "", make: "", model: ""))), viewModel: OdometerViewModel(authenticationViewModel: AuthenticationViewModel()))
}
