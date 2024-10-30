//
//  OdometerReadingIntentError.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import AppIntents

/// An enumeration representing errors that can occur when adding an odometer reading.
///
/// This enum conforms to `Error` and `CustomLocalizedStringResourceConvertible` to provide
/// localized error messages for specific conditions:
///
/// - `invalidDistance`: Triggered when a distance value less than 1 (either in kilometers or miles) is entered.
/// - `emptyVehicles`: Triggered when there are no vehicles available to select for the odometer reading.
///
/// Each case provides a user-friendly localized string resource that describes the error.
enum OdometerReadingIntentError: Error, CustomLocalizedStringResourceConvertible {
    case invalidDistance
    case emptyVehicles
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .invalidDistance:
            LocalizedStringResource(
                "Please add a distance of at least 1 kilometer or mile.",
                comment: "an error shown when entering a zero or negative value for distance"
            )
        case .emptyVehicles:
            LocalizedStringResource(
                "Sorry, there're no vehicles saved to add a reading, please make sure you've saved at least one vehicle. You can do this in the app and then try adding the reading again.",
                comment: "an error shown when attempting to add an odometer while there are no vehicles added"
            )
        }
    }
}
