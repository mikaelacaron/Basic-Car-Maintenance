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
                Text("\(vehicleName ?? "No Name")")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "car.fill")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text("Mileage: \(reading.distance) \(reading.isMetric ? "km" : "mi")")
                } icon: {
                    Image(systemName: "speedometer")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Label {
                    Text("Recorded On: \(reading.date.formatted(date: .abbreviated, time: .omitted))")
                } icon: {
                    Image(systemName: "calendar")
                }
                .font(.caption)
                .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .liquidGlassCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(vehicleName ?? "Vehicle"), \(reading.distance) \(reading.isMetric ? "kilometers" : "miles"), recorded on \(reading.date.formatted(date: .abbreviated, time: .omitted))")
    }
}

#Preview {
    OdometerRowView(reading: .init(date: .now, distance: 1000, isMetric: true, vehicleID: "1234"), 
                vehicleName: "Sample Vehicle Name")
}
