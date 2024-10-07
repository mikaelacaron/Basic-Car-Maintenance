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
        if let error = entry.error {
            Text("Error: \(error)")
        } else {
            VStack {
                ForEach(entry.maintenanceEvents) { event in
                    Text("\(event.vehicleID) - \(event.title)")
                }
            }
        }
    }
}
