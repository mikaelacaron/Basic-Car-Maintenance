//
//  AnalyticsService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import FirebaseAnalytics

class AnalyticsService {
    private init() { }
    
    static let shared = AnalyticsService()
    
    /// Log an `AnalyticEvent` that happened
    /// - Parameter event: The event that happened
    /// - Parameter parameters: Extra parameters for more information about this event, if needed
    func logEvent(_ event: AnalyticEvent, with parameters: [String: String] = [:]) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
    
    func setUserID(_ id: String) {
        Analytics.setUserID(id)
    }
}

enum AnalyticEvent: String {
    
    case maintenanceCreate = "maintenance_create"
    case maintenanceUpdate = "maintenance_update"
    case maintenanceDelete = "maintenance_delete"
    
    case odometerCreate = "odometer_create"
    case odometerUpdate = "odometer_update"
    case odometerDelete = "odometer_delete"
    
    case vehicleCreate = "vehicle_create"
    case vehicleUpdate = "vehicle_update"
    case vehicleDelete = "vehicle_delete"
}
