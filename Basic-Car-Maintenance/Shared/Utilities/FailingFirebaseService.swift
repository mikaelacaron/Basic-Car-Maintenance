//
//  FaillingFirebaseService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
/*
 Abstract: A firebase service that lets tests test failure paths of methods in DashboardViewModel.
 It simply throws an error in all its methods.
 */

import Foundation

enum TestError: Error {
    case failed
}

class FailingFirebaseService: FirebaseServiceProtocol {
    func deleteMaintenanceEvent(_ event: MaintenanceEvent, withDocumentId documentId: String) async throws {
        throw TestError.failed
    }

    func getEvents(withUserUID userUID: String) async throws -> [MaintenanceEvent] {
        throw TestError.failed
    }

    func addMaintenanceEvent(_ event: MaintenanceEvent) throws {
        throw TestError.failed
    }
    
    func updateMaintenanceEvent(_ event: MaintenanceEvent, withId id: String) async throws {
        throw TestError.failed
    }
}
