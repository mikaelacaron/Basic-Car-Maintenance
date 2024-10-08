//
//  Array+Demo.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

extension Array where Element == MaintenanceEvent {
    static var demo: [MaintenanceEvent] {
        [
            MaintenanceEvent(
                vehicleID: "", 
                title: "Tire Rotation", 
                date: .now, 
                notes: "New shiny tires were installed."
            ),
            MaintenanceEvent(
                vehicleID: "", 
                title: "Oil Change", 
                date: .now.advanced(by: -36000), 
                notes: "The cabin air filter was also replaced."
            )
        ]
    }
}
