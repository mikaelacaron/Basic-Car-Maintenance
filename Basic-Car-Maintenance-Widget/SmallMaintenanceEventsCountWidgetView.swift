//
//  SmallMaintenanceView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//


import Firebase
import FirebaseAuth
import WidgetKit
import SwiftUI

struct SmallMaintenanceEventsCountWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        if let error = entry.error, entry.configuration.selectedVehicle != nil {
            ErrorView(error: error)
        } else if let selectedVehicle = entry.configuration.selectedVehicle, let maintenanceEventsCount = entry.maintenanceEventsCount {
            HStack(alignment: .center) {
                CarInfoWithMaintenanceEventsCount(vehicle: selectedVehicle, maintenanceEventsCount: maintenanceEventsCount)
            }
        } else {
            Text("No vehicle selected.")
        }
    }
}


#Preview("General View no maintenance events yet", as: .systemSmall) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEventsCountEntry(date:.now, configuration: .demo, maintenanceEventsCount: 0)
}

#Preview("General View Total 2 maintenance events count", as: .systemSmall) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEventsCountEntry(date:.now, configuration: .demo, maintenanceEventsCount: 2)
}

#Preview("Error View", as: .systemSmall) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEventsCountEntry(date:.now, configuration: .demo, error: "Unexpected error")
}
