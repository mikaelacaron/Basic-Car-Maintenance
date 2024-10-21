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
            Text("\(vehicleName ?? "No Name")")
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text("Mileage: \(reading.distance) \(reading.isMetric ? "km" : "mi")")
                    .foregroundStyle(.gray)
                
                Text("Recorded On: \(reading.date.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    OdometerRowView(reading: .init(date: .now, distance: 1000, isMetric: true, vehicleID: "1234"), 
                vehicleName: "Sample Vehicle Name")
}
