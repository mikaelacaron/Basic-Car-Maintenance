//
//  CSVGeneratorView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation
import SwiftUI

struct CSVGeneratorView: View {
    @Environment(\.dismiss) var dismiss
    
    let events: [MaintenanceEvent]
    let vehicleName: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    Grid(alignment: .leading, verticalSpacing: 5) {
                        GridRow {
                            Text("Date")
                            Text("Vehicle Name")
                            Text("Notes")
                        }
                        .font(.headline)
                        .frame(height: 50)
                        
                        Divider()
                        
                        ForEach(events) { event in
                            GridRow(alignment: .firstTextBaseline) {
                                Text(event.date.formatted())
                                    .frame(maxWidth: 100, maxHeight: .infinity)
                                Text(event.title)
                                Text(event.notes)
                            }
                            .font(.subheadline)
                            if event != events.last {
                                Divider()
                            }
                        }
                    }
                }
                VStack {
                    if let fileURL = generateCSVFile(vehicle: vehicleName) {
                        ShareLink(item: fileURL) {
                            Label("Share", systemImage: SFSymbol.share)
                        }
                    } else {
                        Text("Error: Failed to save CSV file.")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
                .safeAreaPadding(.bottom)
            }
            .toolbar { 
                ToolbarItem(placement: .topBarLeading) { 
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func csvData() -> String {
        let table = CSVTable<MaintenanceEvent>(
            columns: [
                CSVColumn("Date") { $0.date.formatted() },
                CSVColumn("Vehicle Name", \.title),
                CSVColumn("Notes", \.notes)
            ], 
            configuration: CSVEncoderConfiguration() 
        )
        return table.export(rows: events)
    }
    
    private func generateCSVFile(vehicle: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to locate the Documents Directory.")
            return nil
        }
        
        let fileName = "\(vehicle)-MaintenanceReport"
        let fileURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        do {
            try csvData().write(to: fileURL, atomically: true, encoding: .utf8)
            print("File saved to \(fileURL)")
            return fileURL
        } catch {
            print("Failed to save CSV file: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    CSVGeneratorView(
        events: [
            .init(
                vehicleID: "1", 
                title: "1st service", 
                date: .now, 
                notes: "Maintenance and service"
            )], 
        vehicleName: ""
    )
}
