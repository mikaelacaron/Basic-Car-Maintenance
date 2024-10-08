//
//  CarInfo.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct CarInfo: View {
    let vehicle: VehicleAppEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "car")
            Text(vehicle.displayString)
                .font(.title2)
                .bold()
            
            Text("\(vehicle.data.year ?? "") \(vehicle.data.make) \(vehicle.data.model)")
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            Spacer()
        }
    }
}
