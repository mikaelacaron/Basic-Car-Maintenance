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
    static var title: LocalizedStringResource = "Select vehicle"
    // swiftlint:disable:next line_length 
    static var description = IntentDescription("Selects the vehicle to display total number of maintenance events for.")
    
    @Parameter(title: "Selected vehicle")
    var selectedVehicle: VehicleAppEntity?
}
