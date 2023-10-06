//
//  EditMaintenanceEventView.swift
//  Basic-Car-Maintenance
//
//  Created by Aaron Wilson on 10/5/23.
//

import SwiftUI

struct EditMaintenanceEventView: View {
    @Binding var selectedEvent: MaintenanceEvent?
    @ObservedObject var viewModel: DashboardViewModel
    @State private var title = ""
    @State private var date = Date()
    @State private var notes = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
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
            .onAppear {
                guard let selectedEvent = selectedEvent else { return }
                setMaintenanceEventValues(event: selectedEvent)
            }
            .navigationTitle(Text("Add Maintenance"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        var event = MaintenanceEvent(title: title, date: date, notes: notes)
                        guard let selectedEvent = selectedEvent else { return }
                        event.id = selectedEvent.id
                        Task {
                            await viewModel.updateEvent(event)
                            dismiss()
                        }
                    } label: {
                        Text("Update")
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    func setMaintenanceEventValues(event: MaintenanceEvent) {
        self.title = event.title
        self.date = event.date
        self.notes = event.notes
    }
}

#Preview {
    EditMaintenanceEventView(selectedEvent: .constant(MaintenanceEvent(title: "", date: Date(), notes: "")),
                             viewModel: DashboardViewModel(authenticationViewModel: AuthenticationViewModel())
    )
}
