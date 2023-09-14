//
//  AddMaintenanceView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct AddMaintenanceView: View {
    
    let addTapped: (MaintenanceEvent) -> Void
    
    @State private var title = ""
    @State private var date = Date()
    @State private var notes = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title of the maintenance event",
                              text: $title,
                              prompt: Text("The title of the event"))
                } header: {
                    Text("Title")
                }
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date")
                }
                
                Section {
                    TextField("Notes", text: $notes, prompt: Text("Additional Notes"), axis: .vertical)
                } header: {
                    Text("Notes")
                }
            }
            .navigationTitle(Text("Add Maintenance"))
            .toolbar {
                ToolbarItem {
                    Button {
                        let event = MaintenanceEvent(title: title, date: date, notes: notes)
                        addTapped(event)
                        dismiss()
                    } label: {
                        Text("Add")
                    }
                }
            }
            
        }
    }
}

#Preview {
    AddMaintenanceView() { _ in }
}
