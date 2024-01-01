//
//  EditMaintenanceEventView.swift
//  Basic-Car-Maintenance
//
//  Created by Aaron Wilson on 10/5/23.
//

import SwiftUI

struct EditMaintenanceEventView: View {
    @Binding var selectedEvent: MaintenanceEvent?
    var viewModel: DashboardViewModel
    @State private var title = ""
    @State private var date = Date()
    @State private var notes = ""
    @Environment(\.dismiss) var dismiss

    private var vehicleName: String {
        viewModel.vehicles
            .filter { $0.id == selectedEvent?.vehicleID }
            .first?
            .name ?? ""
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                } header: {
                    Text("Title")
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Title: \(title)")
                
                Section {
                    if !vehicleName.isEmpty {
                        Text(vehicleName)
                            .opacity(0.3)
                    }
                } header: {
                    Text("Vehicle")
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Vehicle: \(vehicleName)")
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date")
                        .accessibilityLabel("Date: \(date.toString())")
                }
                .accessibilityInputLabels(["Change date"])
                
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
            .navigationTitle(
                Text("Update Maintenance")
                    .accessibilityLabel("Update Maintenance")
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .accessibilityLabel("Cancel")
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
                            .accessibilityLabel("Update")
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
    EditMaintenanceEventView(selectedEvent:
            .constant(MaintenanceEvent(id: "",
                                       userID: "",
                                       vehicleID: "",
                                       title: "",
                                       date: Date(),
                                       notes: "")),
                             viewModel:
                                DashboardViewModel(userUID: "")
    )
}
