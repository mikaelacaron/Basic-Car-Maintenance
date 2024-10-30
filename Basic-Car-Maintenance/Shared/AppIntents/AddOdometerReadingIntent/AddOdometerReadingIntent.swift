//
//  VehicleQuery.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import AppIntents

/// An `AppIntent` that allows the user to add an odometer reading for a specified vehicle.
///
/// This intent accepts the distance traveled, the unit of distance (miles or kilometers),
/// the vehicle for which the odometer reading is being recorded, and the date of the reading.
///
/// The intent validates the input, ensuring that the distance is a positive integer.
/// If the input is valid, the intent creates an `OdometerReading` and saves it using the `OdometerViewModel`.
/// Upon successful completion, a confirmation dialog is presented to the user.
struct AddOdometerReadingIntent: AppIntent {
    @Dependency private var authViewModel: AuthenticationViewModel

    @Parameter(title: LocalizedStringResource(
        "Vehicle",
        comment: "The selected vehicle to add the odometer reading to.")
    )
    var vehicle: Vehicle?
    
    @Parameter(title: LocalizedStringResource(
        "Date",
        comment: "The date when the reading should be logged.")
    )
    var date: Date
    
    @Parameter(
        title: LocalizedStringResource(
            "Distance Unit",
            comment: "The distance unit in miles or kilometers"
        ),
        requestValueDialog: IntentDialog("In which distance unit would you like to save the entered value?")
    )
    var distanceType: DistanceUnit
    
    @Parameter(title: LocalizedStringResource(
        "Distance",
        comment: "The distance value")
    )
    var distance: Int
        
    static var title = LocalizedStringResource(
        "Add Odometer Reading",
        comment: "Title for the app intent when adding an odometer reading"
    )
    
    private func fetchVehicles() async throws -> [Vehicle] {
        let odometerVM = OdometerViewModel(userUID: authViewModel.user?.uid)
        await odometerVM.getVehicles()
        guard !odometerVM.vehicles.isEmpty else {
            throw OdometerReadingIntentError.emptyVehicles
        }
        return odometerVM.vehicles
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        if distance < 1 {
            throw OdometerReadingIntentError.invalidDistance
        }
        
        let selectVehicle: Vehicle
        if let vehicle {
            selectVehicle = vehicle
        } else {
            let fetchedVehicles = try await fetchVehicles()
            selectVehicle = try await $vehicle.requestDisambiguation(
                among: fetchedVehicles,
                dialog: IntentDialog("Which vehicle would you like to add this to?")
            )
        }
        
        let reading = OdometerReading(
            date: date,
            distance: distance,
            isMetric: distanceType == .kilometer,
            vehicleID: selectVehicle.id
        )
        
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
