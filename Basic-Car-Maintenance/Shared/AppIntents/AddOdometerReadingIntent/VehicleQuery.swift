//
//  VehicleQuery.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import AppIntents

/// The query used to retrieve vehicles for adding odometer.
struct VehicleQuery: EntityQuery {
    @Dependency private var authViewModel: AuthenticationViewModel
    
    func entities(for identifiers: [Vehicle.ID]) async throws -> [Vehicle] {
        try await fetchVehicles()
    }
    
    func suggestedEntities() async throws -> [Vehicle] {
        try await fetchVehicles()
    }
    
    private func fetchVehicles() async throws -> [Vehicle] {
        let odometerVM = OdometerViewModel(userUID: authViewModel.user?.uid)
        await odometerVM.getVehicles()
        guard !odometerVM.vehicles.isEmpty else {
            throw OdometerReadingIntentError.emptyVehicles
        }
        return odometerVM.vehicles
    }
}
