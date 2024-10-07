//
//  CarMaintenanceConfiguration.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import AppIntents

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
struct CarMaintenanceConfiguration: AppIntent, WidgetConfigurationIntent {
    static let intentClassName = "CarMaintenanceConfigurationIntent"

    static var title: LocalizedStringResource = "Car Maintenance Configuration"
    static var description = IntentDescription("")

    @Parameter(title: "Selected Vehicle")
    var selectedVehicle: MaintenanceVehicleAppEntity?

    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$selectedVehicle
        }
    }
}
