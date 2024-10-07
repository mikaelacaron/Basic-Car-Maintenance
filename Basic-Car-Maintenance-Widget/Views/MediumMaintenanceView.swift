//
//  MediumMaintenanceView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import SwiftUI
import WidgetKit

struct MediumMaintenanceView: View {
    var entry: Provider.Entry
    
    var body: some View {
        if entry.configuration.selectedVehicle != nil {
            if let error = entry.error {
                Text("Error: \(error)")
            } else {
                VStack {
                    ForEach(entry.maintenanceEvents) { event in
                        Text("\(event.date.formatted(date: .abbreviated, time: .omitted)) - \(event.title)")
                    }
                }
            }
        } else {
            Text("Select a vehicle first to see maintenance events.")
        }
    }
}
