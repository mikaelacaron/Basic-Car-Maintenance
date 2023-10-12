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
    
    public func logEventVehicleCreated(_ vehicleCreated: AnalyticsEvent) {
        var paramaters: [String: Any] = [:]
        switch vehicleCreated {
        case .vehicleCreated(let vehicleCreatedEvent):
            do {
                let data = try JSONEncoder().encode(vehicleCreatedEvent)
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
                paramaters = dict
            } catch {
                
            }
        }
        print("\n Event: \(vehicleCreated.eventName) | Params: \(paramaters)")
        
        Analytics.logEvent(vehicleCreated.eventName, 
                           parameters: paramaters)
    }
}

enum AnalyticsEvent {
    case vehicleCreated(VehicleCreatedEvent)
    
    var eventName: String {
        switch self {
        case .vehicleCreated: return "vehicle_created"
        }
    }
}

struct VehicleCreatedEvent: Codable {
    let vehicleAction: String
    let origin: String
}
