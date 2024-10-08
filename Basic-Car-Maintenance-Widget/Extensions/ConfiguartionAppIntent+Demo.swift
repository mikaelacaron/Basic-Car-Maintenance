//
//  ConfiguartionAppIntent+Demo.swift
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
            displayString: "Hot Wheels",
            data: .init(name: "Kia Soul", make: "Kia", model: "Soul", year: "2015")
        )
        return intent
    }
}
