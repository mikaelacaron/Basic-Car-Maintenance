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
        if let error = entry.error, entry.configuration.selectedVehicle != nil {
            ErrorView(error: error)
        } else if let selectedVehicle = entry.configuration.selectedVehicle {
                HStack(spacing: 16) {
                    CarInfo(vehicle: selectedVehicle)
                    MaintenanceList(events: entry.maintenanceEvents)
                    Spacer()
            }
        } else {
            Text("No vehicle selected.")
        }
    }
}

#Preview("General View (2 entries)", as: .systemMedium) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEntry(date: .now, configuration: .demo, maintenanceEvents: .demo)
}

#Preview("General View (1 entry)", as: .systemMedium) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEntry(
        date: .now, 
        configuration: .demo, 
        maintenanceEvents: Array([MaintenanceEvent].demo.prefix(1)) 
    )
}

#Preview("General View (0 entries)", as: .systemMedium) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEntry(
        date: .now, configuration: .demo, maintenanceEvents: [])
}

#Preview("Error View", as: .systemMedium) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEntry(date: .now, configuration: .demo, maintenanceEvents: .demo, error: "Unexpected error occurred.")
}
