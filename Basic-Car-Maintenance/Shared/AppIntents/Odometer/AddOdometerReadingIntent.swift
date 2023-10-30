//
//  AddOdometerReadingIntent.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 29/10/2023.
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
        let mainViewModel = MainTabViewModel()
        let vehicles = await mainViewModel.getVehicles()
        guard !vehicles.isEmpty else { throw OdometerReadingError.emptyVehicles }
        return vehicles
    }
}

enum DistanceUnit: String, AppEnum, CaseIterable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Distance Type"
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
        } else if date < Date.now {
            throw OdometerReadingError.invalidDate
        } else {
            let reading = OdometerReading(
                date: date,
                distance: distance,
                isMetric: distanceType == .kilometer,
                vehicle: vehicle
            )
            
            let odometerVM = OdometerViewModel()
            try odometerVM.addReading(reading)
        }
        return .result(dialog: "Added reading successfully")
    }
}

enum OdometerReadingError: Error, CustomLocalizedStringResourceConvertible {
    case invalidDistance
    case emptyVehicles
    case invalidDate
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .invalidDistance:
            "You can not select distance number less than 1 km or mi"
        case .emptyVehicles:
            "No vehicles available, please add a vehicle in the app and try again"
        case .invalidDate:
            "You can not select a past date"
        }
    }
}
