//
//  ExportOptionsView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI
import PDFKit

struct ExportOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedVehicle: Vehicle?
    @State private var isShowingThumbnail = false
    @State private var pdfDoc: PDFDocument?
    
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
                    Button("Export") { 
                        if let selectedVehicle,
                           let events = self.dataSource[selectedVehicle] {
                            let pdfGenerator = CarMaintenancePDFGenerator(
                                vehicleName: selectedVehicle.name,
                                events: events
                            )
                            self.pdfDoc = pdfGenerator.generatePDF() 
                            isShowingThumbnail = true
                        }
                    }
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
        }
    }
}
