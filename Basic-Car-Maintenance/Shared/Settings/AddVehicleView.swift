//
//  AddVehicleView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/25/23.
//

import SwiftUI

struct AddVehicleView: View {
    
    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    
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
                    TextField("Vehicle Model", text: $name, prompt: Text("Vehicle Model"))
                } header: {
                    Text("Model")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
}

#Preview {
    AddVehicleView()
}
