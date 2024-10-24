//
//  MaintenanceList.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct MaintenanceList: View {
    let events: [MaintenanceEvent]
    
    var body: some View {
        VStack {
            if !events.isEmpty {
                ForEach(events.indices.prefix(2), id: \.self) { index in
                    MaintenanceRow(
                        entry: events[index], 
                        borderColor: index.isMultiple(of: 2) ? .mint : .teal
                    )
                }
            } else {
                HStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 3)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle")
                        Text("No maintenance events recorded for this vehicle.")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}

struct MaintenanceRow: View {
    let entry: MaintenanceEvent
    let borderColor: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 3)
                .foregroundStyle(borderColor)
            
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                if !entry.notes.isEmpty {
                    Text(entry.notes)
                        .font(.caption2)
                        .lineLimit(2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.gray)
                    .font(.caption2)
            }
            Spacer()
        }
    }
}
