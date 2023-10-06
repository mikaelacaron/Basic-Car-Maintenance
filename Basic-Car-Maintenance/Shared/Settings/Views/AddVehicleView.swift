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
    private var isVehicleValid: Bool {
        !name.isEmpty && !make.isEmpty && !model.isEmpty
    }
    
    @Environment(\.dismiss) var dismiss
    
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
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        let vehicle = Vehicle(name: name, make: make, model: model)
                        addTapped(vehicle)
//                        dismiss()
                    } label: {
                        Text("Add")
                    }
                    .disabled(!isVehicleValid)
                }
            }
        }
    }
}

#Preview {
    AddVehicleView() { _ in }
}
