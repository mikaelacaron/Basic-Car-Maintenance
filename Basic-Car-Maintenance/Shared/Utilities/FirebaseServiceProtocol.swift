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
    func deleteReading(reading: OdometerReading, documentId: String) async
    func getReadings(userUID: String) async -> [OdometerReading]
    func updateReading(reading: OdometerReading, documentId: String, userUID: String) throws
    func getVehicles(uid: String) async -> [Vehicle]
}
