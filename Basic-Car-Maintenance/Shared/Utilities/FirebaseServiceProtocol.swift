//
//  FirebaseServiceProtocol.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

protocol FirebaseServiceProtocol {
    func addMaintenanceEvent(_ event: MaintenanceEvent) throws
}
