//
//  CarInfoWithMaintenanceEventsCount.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct CarInfoWithMaintenanceEventsCount: View {
    let vehicle: VehicleAppEntity
    let maintenanceEventsCount: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "car")
            Text(vehicle.displayString)
                .font(.subheadline)
                .bold()
            
            Text("\(vehicle.data.year ?? "") \(vehicle.data.make) \(vehicle.data.model)")
                .font(.footnote)
                .foregroundStyle(.gray).padding(.bottom, 2)
            if maintenanceEventsCount > 0 {
                Text("Total events").font(.callout)
                HStack {
                    Image(systemName: SFSymbol.wrenchAndScrewdriver).imageScale(.medium)
                    Text("\(maintenanceEventsCount)").font(.callout)
                }.scaledToFill()
            } else {
                Text("No events yet").font(.callout)
                HStack {
                    Image(systemName: SFSymbol.wrenchAndScrewdriver).imageScale(.medium)
                }.scaledToFill()
            }
        }
    }
}
