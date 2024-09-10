//
//  AddOdometerReadingAppIntent.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 23/08/2024.
//

import Foundation
import AppIntents

/// The query used to retrieve vehicles for adding odometer.
struct VehicleQuery: EntityQuery {
   
    func entities(for identifiers: [Vehicle.ID]) async throws -> [Vehicle] {
        try await fetchVehicles()
    }
    
    func suggestedEntities() async throws -> [Vehicle] {
        try await fetchVehicles()
    }
    
    private func fetchVehicles() async throws -> [Vehicle] {
        let authViewModel = await AuthenticationViewModel()
        let odometerVM = OdometerViewModel(userUID: authViewModel.user?.uid)
        await odometerVM.getVehicles()
        guard !odometerVM.vehicles.isEmpty else {
            throw OdometerReadingError.emptyVehicles
        }
        return odometerVM.vehicles
    }
}

/// An enumeration representing the units of distance used for odometer readings.
///
/// This enum conforms to `AppEnum` and `CaseIterable` to provide display representations
/// for the available distance units: miles and kilometers.
///
/// - `mile`: Represents distance in miles.
/// - `kilometer`: Represents distance in kilometers.
enum DistanceUnit: String, AppEnum, CaseIterable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Distance Type")
    static var caseDisplayRepresentations: [DistanceUnit: DisplayRepresentation] {
        [
            .mile: "Miles",
            .kilometer: "Kilometers"
        ]
    }
    
    case mile
    case kilometer
}

/// An `AppIntent` that allows the user to add an odometer reading for a specified vehicle.
///
/// This intent accepts the distance traveled, the unit of distance (miles or kilometers),
/// the vehicle for which the odometer reading is being recorded, and the date of the reading.
///
/// The intent validates the input, ensuring that the distance is a positive integer.
/// If the input is valid, the intent creates an `OdometerReading` and saves it using the `OdometerViewModel`.
/// Upon successful completion, a confirmation dialog is presented to the user.
struct AddOdometerReadingIntent: AppIntent {
    @Parameter(title: "Distance")
    var distance: Int
    
    @Parameter(
        title: LocalizedStringResource(
            "Distance Unit",
            comment: "The distance unit in miles or kilometers"
        )
    )
    var distanceType: DistanceUnit
    
    @Parameter(title: "Vehicle")
    var vehicle: Vehicle
    
    @Parameter(title: "Date")
    var date: Date
    
    static var title = LocalizedStringResource(
        "Add Odometer Reading",
        comment: "Title for the app intent when adding an odometer reading"
    )
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        if distance < 1 {
            throw OdometerReadingError.invalidDistance
        }
        
        let reading = OdometerReading(
            date: date,
            distance: distance,
            isMetric: distanceType == .kilometer,
            vehicleID: vehicle.id
        )
        let authViewModel = await AuthenticationViewModel()
        let odometerVM = OdometerViewModel(userUID: authViewModel.user?.uid)
        try odometerVM.addReading(reading)
        return .result(
            dialog: IntentDialog(
                LocalizedStringResource(
                    "Added reading successfully",
                    comment: "The message shown when successfully adding an odometer reading using the app intent"
                )
            )
        )
    }
}

/// An enumeration representing errors that can occur when adding an odometer reading.
///
/// This enum conforms to `Error` and `CustomLocalizedStringResourceConvertible` to provide
/// localized error messages for specific conditions:
///
/// - `invalidDistance`: Triggered when a distance value less than 1 (either in kilometers or miles) is entered.
/// - `emptyVehicles`: Triggered when there are no vehicles available to select for the odometer reading.
///
/// Each case provides a user-friendly localized string resource that describes the error.
enum OdometerReadingError: Error, CustomLocalizedStringResourceConvertible {
    case invalidDistance
    case emptyVehicles
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .invalidDistance:
            LocalizedStringResource(
                "You can not select distance number less than 1 km or mi",
                comment: "an error shown when entering a zero or negative value for distance"
            )
        case .emptyVehicles:
            LocalizedStringResource(
                "No vehicles available, please add a vehicle using the app and try again",
                comment: "an error shown when attempting to add an odometer while there are no vehicles added"
            )
            
        }
    }
}
