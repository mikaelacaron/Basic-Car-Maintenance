//
//  DashboardView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var isShowingAddView = false
    
    @State private var events = [MaintenanceEvent]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.title)
                            .font(.title3)
                        
                        Text("\(event.date.formatted(date: .abbreviated, time: .omitted))")
                        
                        Text(event.notes)
                            .lineLimit(0)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle(Text("Dashboard"))
            .onAppear {
                events.append(MaintenanceEvent(id: UUID(), title: "Oil Change", date: Date(), notes: "oil changed by me"))
                events.append(MaintenanceEvent(id: UUID(), title: "Oil Change", date: Date(), notes: "oil changed by me"))
                events.append(MaintenanceEvent(id: UUID(), title: "Oil Change", date: Date(), notes: "oil changed by me"))
                events.append(MaintenanceEvent(id: UUID(), title: "Oil Change", date: Date(), notes: "oil changed by me"))
            }
            .sheet(isPresented: $isShowingAddView) {
                AddMaintenanceView()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingAddView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
