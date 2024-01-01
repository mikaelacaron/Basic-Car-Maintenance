//
//  Date+extension.swift
//  Basic-Car-Maintenance
//
//  Created by Bening Ranum on 31/12/23.
//

import Foundation

extension Date {
    /**
     A simple date-to-string converter with a predefined format style.
     */
    func toString(formatted: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
