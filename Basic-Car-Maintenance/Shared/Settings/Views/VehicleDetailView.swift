//
//  VehicleDetailView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct VehicleDetailView: View {
    
    @Binding var selectedVehicle: Vehicle?
    var viewModel: SettingsViewModel
    
    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var color = ""
    @State private var VIN = ""
    @State private var licensePlateNumber = ""
    
    @State private var isShowingEditVehicleView = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(name)
                } header: {
                    Text("Name")
                }
                
                Section {
                    Text(make)
                } header: {
                    Text("Make")
                }
                
                Section {
                    Text(model)
                } header: {
                    Text("Model")
                }
                
                Section {
                    Text(year)
                } header: {
                    Text("Year")
                }
                
                Section {
                    Text(color)
                } header: {
                    Text("Color")
                }
                
                Section {
                    Text(VIN)
                } header: {
                    Text("VIN")
                }
                
                Section {
                    Text(licensePlateNumber)
                } header: {
                    Text("License Plate Number")
                }
            }
            .analyticsView("\(Self.self)")
            .onAppear {
                guard let selectedVehicle else { return }
                setVehicleValues(selectedVehicle)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingEditVehicleView.toggle()
                    } label: {
                        Text("Edit")
                    }
                }
            }
            .navigationTitle(Text("Vehicle Details", comment: "Label about vehicle details."))
            .sheet(isPresented: $isShowingEditVehicleView) {
                EditVehicleView(
                    selectedVehicle: $selectedVehicle, 
                    viewModel: viewModel, 
                    onVehicleUpdated: setVehicleValues
                )
            }
        }
    }
    
    private func setVehicleValues(_ vehicle: Vehicle) {
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
    
    VehicleDetailView(selectedVehicle: $selectedVehicle, viewModel: viewModel)
}
