//
//  AddOdometerReadingAppIntent.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 23/08/2024.
//

import Foundation
import AppIntents

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

struct AddOdometerReadingIntent: AppIntent {
    @Parameter(title: "Distance")
    var distance: Int
    
    @Parameter(title: "Distance Unit")
    var distanceType: DistanceUnit
    
    @Parameter(title: "Vehicle")
    var vehicle: Vehicle
    
    @Parameter(title: "Date")
    var date: Date
    
    static var title: LocalizedStringResource = "Add Odometer Reading"
    
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
        return .result(dialog: "Added reading successfully")
    }
}

enum OdometerReadingError: Error, CustomLocalizedStringResourceConvertible {
    case invalidDistance
    case emptyVehicles
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .invalidDistance:
            "You can not select distance number less than 1 km or mi"
        case .emptyVehicles:
            "No vehicles available, please add a vehicle using the app and try again"
        }
    }
}
