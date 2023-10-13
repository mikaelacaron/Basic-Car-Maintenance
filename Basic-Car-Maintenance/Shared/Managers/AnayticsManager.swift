//
//  AnayticsManager.swift
//  Basic-Car-Maintenance
//
//  Created by 0xJs on 10/11/23.
//
import Foundation
import FirebaseAnalytics

/// Manager to handle app Analytics
final class AnalyticsManager {
    private init() {}
    
    static let shared = AnalyticsManager()
    
    public func logEvent(_ event: AnalyticsAction, parameters: [String: Any] = [:]) {
        print("\n Event: \(event.rawValue) | Params: \(parameters)")
        
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
}

enum AnalyticsAction: String, Codable {
  case vehicleCreated
  case vehicleUpdated
  case vehicleDeleted
  case maintenanceEventCreated
  case maintenanceEventUpdated
  case maintenanceEventDeleted
}

enum AnalyticsView: String, Codable {
  case addVehicleView
// case updateVehicleView (update?)
  case settingsViewModel
  case addMaintenanceView
  case editEventDetailView
  case dashboardView
}

struct VehicleCreatedEvent: Codable {
  let vehicleAction: AnalyticsAction
  let origin: AnalyticsView
}

struct VehicleUpdatedEvent: Codable {
  let vehicleAction: AnalyticsAction
  let origin: AnalyticsView
}

struct VehicleDeletedEvent: Codable {
  let vehicleAction: AnalyticsAction
  let origin: AnalyticsView
}

struct MaintenanceEventCreatedEvent: Codable {
  let vehicleAction: AnalyticsAction
  let origin: AnalyticsView
}

struct MaintenanceEventUpdatedEvent: Codable {
  let vehicleAction: AnalyticsAction
  let origin: AnalyticsView
}

struct MaintenanceEventDeletedEvent: Codable {
  let vehicleAction: AnalyticsAction
  let origin: AnalyticsView
}
