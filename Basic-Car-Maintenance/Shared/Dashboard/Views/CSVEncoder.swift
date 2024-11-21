//
//  CSVEncoder.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import SwiftUI

struct CSVFile {
    var events: [MaintenanceEvent]
    
    func csvData() -> String {
        let table = CSVTable<MaintenanceEvent>(
            columns: [
                CSVColumn("Date") { $0.date.formatted() },
                CSVColumn("Vehicle Name", \.title),
                CSVColumn("Notes", \.notes)
            ], 
            configuration: CSVEncoderConfiguration(dateEncodingStrategy: .iso8601) 
        )
        return table.export(rows: events)
    }
    
    func generateCSVFile(vehicle: String) -> URL? {
        // Get the path to the Documents Directory
        let fileManager = FileManager.default
            guard let documentsDirectory = fileManager.urls(
                for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to locate the Documents Directory.")
                return nil
            }
        
        // Create the file URL
        let fileName = "\(vehicle)-MaintenanceReport"
        let fileURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        do {
                // Save the CSV content to the file
            try csvData().write(to: fileURL, atomically: true, encoding: .utf8)
                print("File saved to \(fileURL)")
                return fileURL
            } catch {
                print("Failed to save CSV file: \(error.localizedDescription)")
                return nil
            }
    }
}

extension CSVFile: Transferable {
  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(exportedContentType: .commaSeparatedText) { file in
      Data(file.csvData().utf8)
    }
  }
}

internal extension BidirectionalCollection where Element == String {
    var commaDelimited: String { joined(separator: ",") }
    var newlineDelimited: String { joined(separator: "\r\n") }
}

public struct CSVColumn<Record> {
    /// The header name to use for the column in the CSV file's first row.
    public private(set) var header: String
   
    public private(set) var attribute: (Record) -> CSVEncodable
    
    public init(
        _ header: String,
        attribute: @escaping (Record) -> CSVEncodable
    ) {
        self.header = header
        self.attribute = attribute
    }
}

extension CSVColumn {
    public init<T: CSVEncodable> (
        _ header: String,
        _ keyPath: KeyPath<Record, T>
    ) {
        self.init(
            header,
            attribute: { $0[keyPath: keyPath] }
        )
    }
}

public protocol CSVEncodable {
    /// Derive the string representation to be used in the exported CSV.
    func encode(configuration: CSVEncoderConfiguration) -> String
}

extension String: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        self
    }
}

extension Date: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
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
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        uuidString
    }
}

extension Int: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        String(self)
    }
}

extension Double: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        String(self)
    }
}

extension Bool: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        let (trueValue, falseValue) = configuration.boolEncodingStrategy.encodingValues

        return self == true ? trueValue : falseValue
    }
}

extension Optional: CSVEncodable where Wrapped: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        switch self {
        case .none:
            ""
        case .some(let wrapped):
            wrapped.encode(configuration: configuration)
        }
    }
}

extension CSVEncodable {
    internal func escapedOutput(configuration: CSVEncoderConfiguration) -> String {
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

public struct CSVEncoderConfiguration {
    /// The strategy to use when encoding dates.
    public private(set) var dateEncodingStrategy: DateEncodingStrategy = .iso8601
    
    /// The strategy to use when encoding Boolean values.
    public private(set) var boolEncodingStrategy: BoolEncodingStrategy = .trueFalse

    public init(
        dateEncodingStrategy: DateEncodingStrategy = .iso8601,
        boolEncodingStrategy: BoolEncodingStrategy = .trueFalse
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.boolEncodingStrategy = boolEncodingStrategy
    }
    
    /// The strategy to use when encoding `Date` objects for CSV output.
    public enum DateEncodingStrategy {
        case deferredToDate
        case iso8601
        case formatted(DateFormatter)
        case custom(@Sendable (Date) -> String)
    }

    /// The strategy to use when encoding `Bool` objects for CSV output.
    public enum BoolEncodingStrategy {
        case trueFalse
        case trueFalseUppercase
        case yesNo
        case yesNoUppercase
        case integer
        case custom(true: String, false: String)
    }
    public static var `default`: CSVEncoderConfiguration = CSVEncoderConfiguration()
}

internal extension CSVEncoderConfiguration.BoolEncodingStrategy {
    var encodingValues: (String, String) {
        switch self {
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
}

public struct CSVTable<Record> {
    /// A description of all the columns of the CSV file, order from left to right.
    public private(set) var columns: [CSVColumn<Record>]
    /// The set of configuration parameters to use while encoding attributes and the whole file.
    public private(set) var configuration: CSVEncoderConfiguration
    
    /// Create a CSV table definition.
    public init(
        columns: [CSVColumn<Record>],
        configuration: CSVEncoderConfiguration = .default
    ) {
        self.columns = columns
        self.configuration = configuration
    }
    
    /// Constructs a CSV text file structure from the given rows of data.
    public func export(
        rows: any Sequence<Record>
    ) -> String {
        ([headers] + allRows(rows: rows)).newlineDelimited
    }

    // MARK: -

    private var headers: String {
        columns.map { $0.header.escapedOutput(configuration: configuration) }.commaDelimited
    }

    private func allRows(rows: any Sequence<Record>) -> [String] {
        rows.map { row in
            columns.map { $0.attribute(row).escapedOutput(configuration: configuration) }.commaDelimited
        }
    }
}
