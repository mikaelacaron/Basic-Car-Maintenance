//
//  ConfigurableWidgetAppIntent.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

extension ConfigurationAppIntent {
    static var demo: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedVehicle = VehicleAppEntity(
            id: "",
            displayString: "Hot wheels",
            data: .init(name: "Kia Sportage", make: "Kia", model: "Sportage", year: "2022")
        )
        return intent
    }
    
}
