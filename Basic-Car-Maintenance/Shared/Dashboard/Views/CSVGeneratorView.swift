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
    let events: [MaintenanceEvent]
    @Binding var csvFileURL: URL?
    
    var body: some View {
        VStack {
            List {
                Grid {
                    GridRow {
                        Text("Date")
                        Text("Vehicle Name")
                        Text("Notes")
                    }
                    .bold()
                    .frame(height: 40)
                    Divider()
                    ForEach(events) { event in
                        GridRow {
                            Text(event.date.formatted())
                                .frame(maxWidth: 100, maxHeight: .infinity)
                            Text(event.title)
                            Text(event.notes)
                        }
                        if event != events.last {
                            Divider()
                        }
                    }
                }
            }
            VStack {
                if let fileURL = csvFileURL {
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
    }
}

#Preview {
    CSVGeneratorView(
        events: [
            .init(
                vehicleID: "1", 
                title: "Creta", 
                date: .now, 
                notes: "Service"
            ), 
            .init(
                vehicleID: "1", 
                title: "Creta", 
                date: .now,
                notes: "Service")
        ], 
        csvFileURL: .constant(nil)
    )
}
