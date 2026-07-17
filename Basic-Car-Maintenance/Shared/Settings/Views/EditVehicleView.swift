//
//  EditVehicleView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct EditVehicleView: View, Observable {
    @Binding var selectedVehicle: Vehicle?
    var viewModel: SettingsViewModel
    
    /// closure to update the values passed in, and set them to all the state properties
    var onVehicleUpdated: ((Vehicle) -> Void)?
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var color = ""
    @State private var VIN = ""
    @State private var licensePlateNumber = ""
    
    private var isVehicleValid: Bool {
        !name.isEmpty && !make.isEmpty && !model.isEmpty
    }
    
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
                guard let selectedVehicle else { return }
                setEditVehicleValues(selectedVehicle)
            }
            .navigationTitle("Update Vehicle Info")
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
                        if let selectedVehicle {
                            var vehicle = Vehicle(
                                name: name,
                                make: make,
                                model: model,
                                year: year,
                                color: color,
                                vin: VIN,
                                licensePlateNumber: licensePlateNumber)
                            vehicle.id = selectedVehicle.id
                            Task {
                                await viewModel.updateVehicle(vehicle)
                                if let onVehicleUpdated {
                                    onVehicleUpdated(vehicle)
                                }
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Update")
                    }
                    .disabled(!isVehicleValid)
                }
            }
        }
    }
    
    func setEditVehicleValues(_ vehicle: Vehicle) {
        self.name = vehicle.name
        self.make = vehicle.make
        self.model = vehicle.model
        self.year = vehicle.year ?? ""
        self.color = vehicle.color ?? ""
        self.VIN = vehicle.vin ?? ""
        self.licensePlateNumber = vehicle.licensePlateNumber ?? ""
    }
}

#Preview {
    
    @Previewable @State var selectedVehicle: Vehicle? = Vehicle(
        id: UUID().uuidString,
        name: "My Car",
        make: "Ford",
        model: "F-150",
        year: "2020",
        color: "Red",
        vin: "5YJSA1E26JF123456",
        licensePlateNumber: "ABC123"
    )
    let viewModel = SettingsViewModel(authenticationViewModel: AuthenticationViewModel())

    EditVehicleView(selectedVehicle: $selectedVehicle, viewModel: viewModel)
    
}
