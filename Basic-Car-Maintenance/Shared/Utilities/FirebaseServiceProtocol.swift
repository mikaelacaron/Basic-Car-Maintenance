//
//  FirebaseServiceProtocol.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

protocol FirebaseServiceProtocol {
    func addReading(_ reading: OdometerReading) throws
    func deleteReading(_ reading: OdometerReading) async
    func updateReading(_ reading: OdometerReading) throws
    func getReadings(userUID: String) async -> [OdometerReading]
    func getVehicles(userUID: String) async -> [Vehicle]
}
