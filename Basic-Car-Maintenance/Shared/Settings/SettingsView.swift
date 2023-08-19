//
//  SettingsView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Text("Thanks for using this app! It's open source and anyone can contribute to its development.")
                
                Text("Version \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))")
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    SettingsView()
}
