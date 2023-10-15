//
//  EditOdometerReadingDetailView.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import SwiftUI

struct EditOdometerReadingDetailView: View {
    @Binding var selectedReading: OdometerReading?
    var viewModel: OdometerViewModel
    @State private var date = Date()
    @State private var selectedVehicle: Vehicle?
    @State private var distance = 0
    @State private var unitsAreMetric = true
    @State private var switchUnitModalIsPresented = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        TextField("Distance", value: $distance, format: .number)
                        Button("Unit") {
                            switchUnitModalIsPresented = true
                        }
                    }
                    .sheet(isPresented: $switchUnitModalIsPresented) {
                        Toggle(isOn: $unitsAreMetric) {
                            Text(unitsAreMetric ? "Kilometers" : "Miles")
                        }
                        .presentationDetents([.height(100)])
                    }
                } header: {
                    Text("Distance in \(unitsAreMetric ? "Kilometers" : "Miles")")
                }
                
                Section {
                    Picker(selection: $selectedVehicle) {
                        ForEach(viewModel.vehicles) { vehicle in
                            Text(vehicle.name).tag(vehicle as Vehicle)
                        }
                    } label: {
                        Text("Select a vehicle",
                             comment: "Odometer Reading vehicle picker label")
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
            .onAppear {
                guard let selectedReading = selectedReading else { return }
                setOdometerReadingValues(reading: selectedReading)
            }
            .navigationTitle(Text("Update Odometer Reading"))
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
                        if let selectedVehicle, let selectedReading {
                            var reading = OdometerReading(date: date,
                                                          distance: distance,
                                                          unitsAreMetric: unitsAreMetric,
                                                          vehicle: selectedVehicle)
                            reading.id = selectedReading.id
                            Task {
                                await viewModel.updateReading(reading)
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Update")
                    }
                    .disabled(distance == 0)
                }
            }
        }
    }
    
    func setOdometerReadingValues(reading: OdometerReading) {
        self.date = reading.date
        self.distance = reading.distance
        self.unitsAreMetric = reading.unitsAreMetric
        self.selectedVehicle = reading.vehicle
    }

}

#Preview {
    EditOdometerReadingDetailView(selectedReading:
            .constant(
                OdometerReading(
                    date: Date(),
                    distance: 0,
                    unitsAreMetric: false,
                    vehicle:
                        Vehicle(
                            name: "",
                            make: "",
                            model: ""))),
                          viewModel:
                                    OdometerViewModel(authenticationViewModel:
                                                        AuthenticationViewModel())
    )
}
