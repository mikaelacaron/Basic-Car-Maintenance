//
//  CarMaintenancePDFGenerator.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import UIKit
import PDFKit

final class CarMaintenancePDFGenerator {
    private let vehicleName: String
    private let events: [MaintenanceEvent]
    
    // Define page margins
    private let topMargin: CGFloat = 50
    private let bottomMargin: CGFloat = 50
    private let leftMargin: CGFloat = 20
    private let rightMargin: CGFloat = 20
    private let columnWidth: CGFloat
    private let documentsDirectory = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first
    
    init(vehicleName: String, events: [MaintenanceEvent]) {
        self.vehicleName = vehicleName
        self.events = events
        self.columnWidth = (PageDimension.A4.pageWidth - leftMargin - rightMargin) / 3
    }
    
    func generatePDF() -> PDFDocument? {
        guard !events.isEmpty else { return nil }
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: PageDimension.A4.size))
        let pdfData = pdfRenderer.pdfData { context in            
            var yPosition: CGFloat = topMargin
            
            beginNewPage(
                context: context,
                yPosition: &yPosition,
                isFirstPage: true
            )
            
            let tableRowAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]
                        
            for (index, event) in events.enumerated() {
                if yPosition + 60 > PageDimension.A4.pageHeight - bottomMargin {
                    beginNewPage(
                        context: context,
                        yPosition: &yPosition,
                        isFirstPage: index == 0
                    )
                }
                
                event.date
                    .formatted()
                    .draw(at: CGPoint(x: leftMargin, y: yPosition), withAttributes: tableRowAttributes)
                
                vehicleName.draw(
                    at: CGPoint(x: leftMargin + columnWidth, y: yPosition),
                    withAttributes: tableRowAttributes
                )
                
                let notesRect = CGRect(
                    x: leftMargin + 2 * columnWidth,
                    y: yPosition,
                    width: columnWidth - 20,
                    height: 50
                )
                event.notes.draw(in: notesRect, withAttributes: tableRowAttributes)
                
                yPosition += 60
            }
        }
        
        do {
            guard let fileURL = documentsDirectory?
                .appendingPathComponent("\(vehicleName)-MaintenanceReport.pdf") 
            else { return nil }
            
            if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
                try FileManager.default.removeItem(at: fileURL)
            }
            
            try pdfData.write(to: fileURL)
            print("PDF saved to: \(fileURL.path)")
            return PDFDocument(url: fileURL)
        } catch {
            print("Could not save the PDF: \(error)")
            return nil
        }
    }
    
    /// Draw the center header and header columns
    private func drawHeader(context: UIGraphicsPDFRendererContext, yPosition: inout CGFloat) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        
        let titleString = "Basic Car Maintenance"
        let eventTitleString = "Maintenance Events"
        guard 
            let startDate = events.first?.date.formatted(date: .numeric, time: .omitted),
            let endDate = events.last?.date.formatted(date: .numeric, time: .omitted)
        else { return }
        let dateRangeString = "From \(startDate) to \(endDate)"
        
        let titleSize = titleString.size(withAttributes: titleAttributes)
        let vehicleSize = vehicleName.size(withAttributes: subtitleAttributes)
        let eventTitleSize = eventTitleString.size(withAttributes: subtitleAttributes)
        let dateRangeSize = dateRangeString.size(withAttributes: subtitleAttributes)
        
        let titleX = (PageDimension.A4.pageWidth - titleSize.width) / 2
        let vehicleX = (PageDimension.A4.pageWidth - vehicleSize.width) / 2
        let eventTitleX = (PageDimension.A4.pageWidth - eventTitleSize.width) / 2
        let dateRangeX = (PageDimension.A4.pageWidth - dateRangeSize.width) / 2
        
        titleString.draw(at: CGPoint(x: titleX, y: yPosition), withAttributes: titleAttributes)
        yPosition += 30
        
        vehicleName.draw(at: CGPoint(x: vehicleX, y: yPosition), withAttributes: subtitleAttributes)
        yPosition += 30
        
        eventTitleString.draw(at: CGPoint(x: eventTitleX, y: yPosition), withAttributes: subtitleAttributes)
        yPosition += 30
        
        dateRangeString.draw(at: CGPoint(x: dateRangeX, y: yPosition), withAttributes: subtitleAttributes)
        yPosition += 50
        
        drawColumnsHeaders(yPosition: &yPosition)
    }
    
    private func beginNewPage(
        context: UIGraphicsPDFRendererContext,
        yPosition: inout CGFloat,
        isFirstPage: Bool
    ) {
        context.beginPage()
        yPosition = topMargin
        
        if isFirstPage {
            drawHeader(context: context, yPosition: &yPosition)
        }
    }
    
    private func drawColumnsHeaders(yPosition: inout CGFloat) {
        let dateColumnHeader = "Date"
        let vehicleColumnHeader = "Vehicle Name"
        let noteColumnHeader = "Notes"
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        
        dateColumnHeader.draw(
            at: CGPoint(x: leftMargin, y: yPosition),
            withAttributes: subtitleAttributes
        )
        
        vehicleColumnHeader.draw(
            at: CGPoint(x: leftMargin + columnWidth, y: yPosition),
            withAttributes: subtitleAttributes
        )
        
        let notesRect = CGRect(
            x: leftMargin + 2 * columnWidth,
            y: yPosition,
            width: columnWidth - 20,
            height: 50
        )
        noteColumnHeader.draw(in: notesRect, withAttributes: subtitleAttributes)
        
        yPosition += 30
    } 
}
