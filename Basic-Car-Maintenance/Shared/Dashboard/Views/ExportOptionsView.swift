//
//  ExportOptionsView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI
import PDFKit

enum ExportOption: String, Identifiable, CaseIterable {
    case pdf = "PDF"
    case csv = "CSV"
    var id: Self { self }
}

struct ExportOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedVehicle: Vehicle?
    @State private var isShowingThumbnail = false
    @State private var pdfDoc: PDFDocument?
    @State private var showingErrorAlert = false
    @State private var selectedOption: ExportOption?
    @State private var showingCSVExporter = false
    
    private let dataSource: [Vehicle: [MaintenanceEvent]]
    
    init(dataSource: [Vehicle: [MaintenanceEvent]]) {
        self.dataSource = dataSource
        self._selectedVehicle = State(initialValue: dataSource.first?.key)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Select the vehicle you want to export the maintenance events for:")
                    .font(.headline)
                    .padding(.top, 20)
                
                Picker("Select a Vehicle", selection: $selectedVehicle) {
                    ForEach(dataSource.map(\.key)) { vehicle in
                        Text(vehicle.name)
                            .tag(vehicle)
                    }
                }
                .pickerStyle(.wheel)
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Export", selection: $selectedOption) {
                            ForEach(ExportOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Text("Export")
                    }
                    .onChange(of: selectedOption, { _, _ in
                        if let selectedVehicle,
                           let events = self.dataSource[selectedVehicle] {
                            if !events.isEmpty {
                                switch selectedOption {
                                case .pdf:
                                    selectedOption = nil
                                    let pdfGenerator = CarMaintenancePDFGenerator(
                                        vehicleName: selectedVehicle.name,
                                        events: events
                                    )
                                    self.pdfDoc = pdfGenerator.generatePDF() 
                                    isShowingThumbnail = true
                                case .csv:
                                    selectedOption = nil
                                    showingCSVExporter = true
                                case .none:
                                    print("No option selected, do nothing")
                                }
                            } else {
                                showingErrorAlert = true
                            }
                        }
                    })
                }
            }
            .sheet(isPresented: $isShowingThumbnail) {
                if let pdfDoc,
                   let url = pdfDoc.documentURL,
                   let thumbnail = pdfDoc
                    .page(at: .zero)?
                    .thumbnail(
                        of: CGSize(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height / 2),
                        for: .mediaBox
                    ) {
                    ShareLink(item: url) {
                        VStack {
                            Image(uiImage: thumbnail)
                            Label("Share", systemImage: SFSymbol.share)
                        }
                        .safeAreaPadding(.bottom)
                    }
                    .presentationDetents([.medium])
                }
            }
            .sheet(isPresented: $showingCSVExporter) { 
                if let selectedVehicle,
                   let events = self.dataSource[selectedVehicle] {
                    CSVGeneratorView(events: events, vehicleName: selectedVehicle.name)
                        .presentationDetents([.medium])
                }
            }
            .alert(
                Text(
                    "Failed to Export Events",
                    comment: "Title for alert shown when there are no events to export for a vehicle"
                ),
                isPresented: $showingErrorAlert) {
                    Button {
                        showingErrorAlert = false
                    } label: {
                        Text("OK", comment: "Label to dismiss alert")
                    }
                } message: {
                    Text("No events to export for this vehicle.")
                }
        }
    }
}
