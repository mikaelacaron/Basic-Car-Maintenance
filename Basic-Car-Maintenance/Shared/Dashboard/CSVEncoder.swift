//
//  CSVEncoder.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

extension BidirectionalCollection where Element == String {
    var commaDelimited: String { joined(separator: ",") }
    var newlineDelimited: String { joined(separator: "\r\n") }
}

struct CSVColumn<Record> {
    /// The header name to use for the column in the CSV file's first row.
    private(set) var header: String
   
    private(set) var attribute: (Record) -> CSVEncodable
    
    init( _ header: String, attribute: @escaping (Record) -> CSVEncodable) {
        self.header = header
        self.attribute = attribute
    }
    
    init<T: CSVEncodable> (_ header: String, _ keyPath: KeyPath<Record, T>) {
        self.init(header, attribute: { $0[keyPath: keyPath] })
    }
}

protocol CSVEncodable {
    /// Derive the string representation to be used in the exported CSV.
    func encode(configuration: CSVEncoderConfiguration) -> String
}

extension String: CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String {
        self
    }
}

extension Date: CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String {
        switch configuration.dateEncodingStrategy {
        case .deferredToDate:
            String(self.timeIntervalSinceReferenceDate)
        case .iso8601:
            ISO8601DateFormatter().string(from: self)
        case .formatted(let dateFormatter):
            dateFormatter.string(from: self)
        case .custom(let customFunc):
            customFunc(self)
        }
    }
}

extension UUID: CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String {
        uuidString
    }
}

extension Int: CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String {
        String(self)
    }
}

extension Double: CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String {
        String(self)
    }
}

extension Bool: CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String {
        let (trueValue, falseValue) = configuration.encodingValues

        return self == true ? trueValue : falseValue
    }
}

extension Optional: CSVEncodable where Wrapped: CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String {
        switch self {
        case .none:
            ""
        case .some(let wrapped):
            wrapped.encode(configuration: configuration)
        }
    }
}

extension CSVEncodable {
    func escapedOutput(configuration: CSVEncoderConfiguration) -> String {
        let output = self.encode(configuration: configuration)
        if output.contains(",") || output.contains("\"") || output.contains(#"\n"#)
            || output.hasPrefix(" ") || output.hasSuffix(" ") {
            // Escape existing double quotes by doubling them
            let escapedQuotes = output.replacingOccurrences(of: "\"", with: "\"\"")

            // Wrap the string in double quotes
            return "\"\(escapedQuotes)\""
        } else {
            // No special characters, return as is
            return output
        }
    }
}

struct CSVEncoderConfiguration {
    /// The strategy to use when encoding dates.
    private(set) var dateEncodingStrategy: DateEncodingStrategy = .iso8601
    
    /// The strategy to use when encoding Boolean values.
    private(set) var boolEncodingStrategy: BoolEncodingStrategy = .trueFalse

    init(
        dateEncodingStrategy: DateEncodingStrategy = .iso8601,
        boolEncodingStrategy: BoolEncodingStrategy = .trueFalse
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.boolEncodingStrategy = boolEncodingStrategy
    }
    
    /// The strategy to use when encoding `Date` objects for CSV output.
    enum DateEncodingStrategy {
        case deferredToDate
        case iso8601
        case formatted(DateFormatter)
        case custom(@Sendable (Date) -> String)
    }

    /// The strategy to use when encoding `Bool` objects for CSV output.
    enum BoolEncodingStrategy {
        case trueFalse
        case trueFalseUppercase
        case yesNo
        case yesNoUppercase
        case integer
        case custom(true: String, false: String)
    }
    
    var encodingValues: (String, String) {
        switch boolEncodingStrategy {
        case .trueFalse:
            return ("true", "false")
        case .trueFalseUppercase:
            return ("TRUE", "FALSE")
        case .yesNo:
            return ("yes", "no")
        case .yesNoUppercase:
            return ("YES", "NO")
        case .integer:
            return ("1", "0")
        case .custom(let trueValue, let falseValue):
            return (trueValue, falseValue)
        }
    }
    
    static var `default`: CSVEncoderConfiguration = CSVEncoderConfiguration()
}

struct CSVTable<Record> {
    /// A description of all the columns of the CSV file, order from left to right.
    private(set) var columns: [CSVColumn<Record>]
    
    /// The set of configuration parameters to use while encoding attributes and the whole file.
    private(set) var configuration: CSVEncoderConfiguration
    
    private var headers: String {
        columns.map { $0.header.escapedOutput(configuration: configuration) }.commaDelimited
    }
    
    /// Create a CSV table definition.
    init(
        columns: [CSVColumn<Record>],
        configuration: CSVEncoderConfiguration = .default
    ) {
        self.columns = columns
        self.configuration = configuration
    }
    
    /// Constructs a CSV text file structure from the given rows of data.
    func export(rows: any Sequence<Record>) -> String {
        ([headers] + allRows(rows: rows)).newlineDelimited
    }

    private func allRows(rows: any Sequence<Record>) -> [String] {
        rows.map { row in
            columns.map { $0.attribute(row).escapedOutput(configuration: configuration) }.commaDelimited
        }
    }
}
