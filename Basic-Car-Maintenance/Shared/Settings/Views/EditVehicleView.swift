//
//  EditVehicleView.swift
//  Basic-Car-Maintenance
//
//  Created by Traton Gossink on 11/6/23.
//

import SwiftUI

struct EditVehicleView: View, Observable {
    @Binding var selectedEvent: EditVehicleEvent?
    var viewModel: SettingsViewModel
    @State private var selectedVehicle: Vehicle?
    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var color = ""
    @State private var VIN = ""
    @State private var licensePlateNumber = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                } header: {
                    Text("Name")
                }
                Section {
                    TextField("Make", text: $make)
                } header: {
                    Text("Make")
                }
                
                Section {
                    TextField("Model", text: $model)
                } header: {
                    Text("Model")
                }
                
                Section {
                    TextField("Year", text: $year)
                } header: {
                    Text("Year")
                }
                
                Section {
                    TextField("Color", text: $color)
                } header: {
                    Text("Color")
                }
                Section {
                    TextField("VIN", text: $VIN)
                } header: {
                    Text("VIN")
                }
                Section {
                    TextField("License Plate Number", text: $licensePlateNumber)
                } header: {
                    Text("License Plate Number")
                }
            }
            .analyticsView("\(Self.self)")
            .onAppear {
                guard let selectedEvent = selectedEvent else { return }
                setEditVehicleEventValues(event: selectedEvent)
            }
            .navigationTitle(Text("Update Vehicle Info"))
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
                        if let selectedVehicle, let selectedEvent {
                            var event = EditVehicleEvent(name: name,
                                                         make: make,
                                                         model: model,
                                                         year: year,
                                                         color: color,
                                                         VIN: VIN,
                                                         licenseplatenumber: licensePlateNumber,
                            vehicle: selectedVehicle)
                            event.id = selectedEvent.id
                            Task {
                                await viewModel.updateEvent(event)
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Update")
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    func setEditVehicleEventValues(event: EditVehicleEvent) {
        self.name = event.name
        self.make = event.make
        self.model = event.model
        self.year = event.year
        self.color = event.color
        self.VIN = event.VIN
        self.licensePlateNumber = event.licenseplatenumber
        self.selectedVehicle = event.vehicle
    }
}

#Preview {
    EditVehicleView(selectedEvent:
            .constant(EditVehicleEvent(name: "", make: "", model: "", year: "", color: "", VIN: "", licenseplatenumber: "")),
                             viewModel:
                                SettingsViewModel(authenticationViewModel: AuthenticationViewModel())
    )
}
