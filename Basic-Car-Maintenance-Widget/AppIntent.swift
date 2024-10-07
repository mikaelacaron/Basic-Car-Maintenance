//
//  AppIntent.swift
//  Basic-Car-Maintenance-Widget
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Current Vehicle"
    static var description = IntentDescription("See the current vehicle's maintenance events")

    // An example configurable parameter.
    @Parameter(title: "Vehichle")
    var selectedVehicle: MaintenanceVehicleAppEntity?
}
