//
//  DistanceUnit.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import AppIntents

/// An enumeration representing the units of distance used for odometer readings.
///
/// This enum conforms to `AppEnum` and `CaseIterable` to provide display representations
/// for the available distance units: miles and kilometers.
///
/// - `mile`: Represents distance in miles.
/// - `kilometer`: Represents distance in kilometers.
enum DistanceUnit: String, AppEnum {
    case mile
    case kilometer
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Distance Type")
    static var caseDisplayRepresentations: [DistanceUnit: DisplayRepresentation] {
        [
            .mile: "Miles",
            .kilometer: "Kilometers"
        ]
    }
}
