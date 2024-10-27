//
//  MeasurementSystem.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

enum MeasurementSystem: String, Identifiable, CaseIterable {
    case imperial
    case metric
    
    var id: UUID { UUID() }
    var title: String {
        switch self {
        case .imperial:
            return NSLocalizedString("Imperial", comment: "Imperial unit system")
        case .metric:
            return NSLocalizedString("Metric", comment: "Metric unit system")
        }
    }    
    
    static var `default`: MeasurementSystem {
        switch Locale.current.measurementSystem {
        case .uk:
            return .metric
        case .us:
            return .imperial
        default:
            return .metric
        }
    }
}
