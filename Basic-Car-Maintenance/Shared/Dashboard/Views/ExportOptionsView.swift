//
//  ExportOptionsView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

protocol MaintenanceEventsFetcher {
    func fetchEvents(for vehicle: Vehicle) -> [MaintenanceEvent]
}

struct ExportOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedVehicle: Vehicle?
    @State private var isShowingShareSheet = false
    private let eventsFetcher: MaintenanceEventsFetcher
    private let onExport: (URL) -> Void
    private let vehicles: [Vehicle]
    
    init(
        vehicles: [Vehicle],
        eventsFetcher: MaintenanceEventsFetcher,
        onExport: @escaping (URL) -> Void
    ) {
        self.vehicles = vehicles
        self.eventsFetcher = eventsFetcher
        self.onExport = onExport
        self._selectedVehicle = State(initialValue: vehicles.first)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Select the vehicle you want to export the maintenance events for:")
                    .font(.headline)
                    .padding(.top, 20)
                
                Picker("Select a Vehicle", selection: $selectedVehicle) {
                    ForEach(vehicles, id: \.id) { vehicle in
                        Text(vehicle.name)
                            .tag(vehicle as Vehicle?)
                    }
                }
                .pickerStyle(InlinePickerStyle())
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Export") { 
                        if let selectedVehicle {
                            let events = eventsFetcher.fetchEvents(for: selectedVehicle)
                            let pdfGenerator = CarMaintenancePDFGenerator(
                                vehicleName: selectedVehicle.name,
                                events: events
                            )
                            if let pdfURL = pdfGenerator.generatePDF() {
                                onExport(pdfURL)
                                dismiss()
                            }
                        }
                    }
                    .disabled(selectedVehicle == nil)
                }
            }
        }
    }
}
