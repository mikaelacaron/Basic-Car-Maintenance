//
//  ReadingView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct ReadingView: View {
    private let reading: OdometerReading
    private let vehicleName: String?
    
    init(odometerReading: OdometerReading, vehicleName: String?) {
        self.reading = odometerReading
        self.vehicleName = vehicleName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(vehicleName ?? "No Name")").font(.title)

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
    ReadingView(odometerReading: .init(date: .now, distance: 1000, isMetric: true, vehicleID: "1234"), 
                vehicleName: "Sample Vehicle Name")
}
