//
//  AddVehicleView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/25/23.
//

import SwiftUI

struct AddVehicleView: View {
    
    let addTapped: (Vehicle) -> Void
    
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
                    TextField("Vehicle Name", text: $name, prompt: Text("Vehicle Name"))
                } header: {
                    Text("Name")
                }
                
                Section {
                    TextField("Vehicle Make", text: $make, prompt: Text("Vehicle Make"))
                } header: {
                    Text("Make")
                }
                
                Section {
                    TextField("Vehicle Model", text: $model, prompt: Text("Vehicle Model"))
                } header: {
                    Text("Model")
                }

                Section {
                    TextField("Vehicle Year", text: $year, prompt: Text("Vehicle Year"))
                        .keyboardType(.numberPad)
                } header: {
                    Text("Year")
                }

                Section {
                    TextField("Vehicle Color", text: $color, prompt: Text("Vehicle Color"))
                } header: {
                    Text("Color")
                }

                Section {
                    TextField("Vehicle VIN", text: $VIN, prompt: Text("Vehicle VIN"))
                        .textInputAutocapitalization(.characters)
                } header: {
                    Text("VIN")
                }

                Section {
                    TextField("Vehicle License Plate Number",
                              text: $licensePlateNumber,
                              prompt: Text("Vehicle License Plate Number"))
                    .textInputAutocapitalization(.characters)
                } header: {
                    Text("License Plate Number")
                }
            }
            .analyticsView("\(Self.self)")
            .toolbar {
                ToolbarItem {
                    Button {
                        let vehicle = Vehicle(name: name, 
                                              make: make,
                                              model: model,
                                              year: year,
                                              color: color,
                                              vin: VIN,
                                              licensePlateNumber: licensePlateNumber)
                        addTapped(vehicle)
                    } label: {
                        Text("Add")
                    }
                    .disabled(!isVehicleValid)
                }
            }
            .navigationTitle(Text("Add Vehicle", comment: "Label to add a vehicle."))
        }
    }
}

#Preview {
    AddVehicleView() { _ in }
}
