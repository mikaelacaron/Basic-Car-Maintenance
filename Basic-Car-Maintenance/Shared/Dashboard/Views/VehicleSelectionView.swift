//
//  VehicleSelectionView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct VehicleSelectionView: View {
    @Binding var selectedVehicle: Vehicle?
    
    var vehicles: [Vehicle]
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {  
                Button {
                    selectedVehicle = nil
                    dismiss()
                } label: {
                    Text("All Vehicles")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                ForEach(vehicles) { vehicle in
                    Button {
                        selectedVehicle = vehicle
                        dismiss()
                    } label: {
                        Text(vehicle.name)
                    }
                }
            }
            .navigationTitle("Select Vehicle")
        }
    }
}
