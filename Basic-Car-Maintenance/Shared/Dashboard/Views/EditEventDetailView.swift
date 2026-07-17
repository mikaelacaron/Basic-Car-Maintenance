//
//  EditMaintenanceEventView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct EditMaintenanceEventView: View {
    @Binding var selectedEvent: MaintenanceEvent?
    var viewModel: DashboardViewModel
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
                
                Section {
                    if let vehicleName = viewModel.vehicles
                        .filter({ $0.id == selectedEvent?.vehicleID }).first?.name {
                        Text(vehicleName)
                            .opacity(0.3)
                    }
                } header: {
                    Text("Vehicle")
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
            .analyticsView("\(Self.self)")
            .onAppear {
                guard let selectedEvent = selectedEvent else { return }
                setMaintenanceEventValues(event: selectedEvent)
            }
            .navigationTitle(Text("Update Maintenance"))
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
                        if let selectedEvent {
                            var event = MaintenanceEvent(vehicleID: selectedEvent.vehicleID,
                                                         title: title,
                                                         date: date,
                                                         notes: notes)
                            event.id = selectedEvent.id
                            Task {
                                await viewModel.updateEvent(event)
                                dismiss()
                            }
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

#Preview() {
      
    @Previewable @State var selectedEvent: MaintenanceEvent? = MaintenanceEvent(
        id: UUID().uuidString,
        userID: "user123",
        vehicleID: "vehicle123",
        title: "Oil Change",
        date: Date(),
        notes: "Changed engine oil"
    )
    
    let viewModel = DashboardViewModel(userUID: "user123")
    
    EditMaintenanceEventView(
        selectedEvent: $selectedEvent,
        viewModel: viewModel
    )
}
