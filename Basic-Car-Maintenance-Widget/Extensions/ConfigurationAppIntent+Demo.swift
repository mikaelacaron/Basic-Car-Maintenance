//
//  ConfigurableWidgetAppIntent.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

extension ConfigurationAppIntent {
    static var demo: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedVehicle = VehicleAppEntity(
            id: UUID().uuidString,
            displayString: "Hot wheels",
            data: .init(name: "Kia Sportage", make: "Kia", model: "Sportage", year: "2022")
        )
        return intent
    }
}
