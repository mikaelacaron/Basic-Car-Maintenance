//
//  OdometerRowView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct OdometerRowView: View {
    let reading: OdometerReading
    let vehicleName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: SFSymbol.carFill)
                
                Text(vehicleName ?? "No Name")
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text("\(reading.distance) \(reading.isMetric ? "km" : "mi")")
                } icon: {
                    Image(systemName: SFSymbol.gaugeWithNeedle)
                }
                
                Label {
                    Text(reading.date.formatted(date: .abbreviated, time: .omitted))
                } icon: {
                    Image(systemName: SFSymbol.calendar)
                }
            }
        }
    }
}

#Preview {
    OdometerRowView(reading: .init(date: .now, distance: 1000, isMetric: true, vehicleID: "1234"), 
                    vehicleName: "Sample Vehicle Name")
}
