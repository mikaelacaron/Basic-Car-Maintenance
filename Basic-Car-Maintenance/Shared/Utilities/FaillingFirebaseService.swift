//
//  FaillingFirebaseService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//


enum TestError: Error {
    case failed
}

class FaillingFirebaseService: FirebaseServiceProtocol {
    func addMaintenanceEvent(_ event: MaintenanceEvent) throws {
        throw TestError.failed
    }
}
