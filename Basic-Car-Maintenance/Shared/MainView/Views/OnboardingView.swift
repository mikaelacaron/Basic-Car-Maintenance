//
//  OnboardingView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 11/5/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    
    var body: some View {
        Form {
            Section {
                Text("Welcome to Basic Car Maintenance!")
                    .font(.title)
                
                Text("Get started by adding a vehicle")
            }
            
            Section {
                TextField("Name", text: $name)
                TextField("Make", text: $make)
                TextField("Model", text: $model)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
