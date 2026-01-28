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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: SFSymbol.carFill)
                    .foregroundStyle(.secondary)
                Text(vehicleName ?? "No Name")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text("\(reading.distance) \(reading.isMetric ? "kilometers" : "miles")")
                } icon: {
                    Image(systemName: SFSymbol.speedometer)
                }
                
                Label {
                    Text(reading.date.formatted(date: .abbreviated, time: .omitted))
                } icon: {
                    Image(systemName: SFSymbol.calendar)
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    OdometerRowView(reading: .init(date: .now, distance: 1000, isMetric: true, vehicleID: "1234"), 
                vehicleName: "Sample Vehicle Name")
}
