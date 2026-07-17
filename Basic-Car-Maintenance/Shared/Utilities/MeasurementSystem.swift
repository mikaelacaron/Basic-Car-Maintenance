//
//  MeasurementSystem.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

enum MeasurementSystem: String, Identifiable, CaseIterable {
    case imperial
    case metric
    
    var id: String {
        return rawValue
    }
    
    var title: LocalizedStringResource {
        switch self {
        case .imperial:
            return LocalizedStringResource(
                "Imperial",
                defaultValue: "Imperial",
                comment: "Imperial unit system"
            )
        case .metric:
            return LocalizedStringResource("Metric", defaultValue: "Metric", comment: "Metric unit system")
        }
    }    
    
    static var userDefault: MeasurementSystem {
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
