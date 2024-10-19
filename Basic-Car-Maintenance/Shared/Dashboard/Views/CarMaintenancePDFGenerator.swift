//
//  CarMaintenancePDFGenerator.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import UIKit
import SwiftUI

protocol PDFGeneratable {
    func generatePDF() -> URL?
}

final class CarMaintenancePDFGenerator: PDFGeneratable {
    private let title = "Basic Car Maintenance" 
    private let vehicleName: String
    private let events: [MaintenanceEvent]
    // Define the PDF page size (A4 size in points)
    private let pageWidth: CGFloat = 595.2
    private let pageHeight: CGFloat = 841.8
    private var pageSize: CGSize
    
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
        self.pageSize = CGSize(width: pageWidth, height: pageHeight)
        self.columnWidth = (pageWidth - leftMargin - rightMargin) / 3 
    }
    
    func generatePDF() -> URL? {
        guard !events.isEmpty else { return nil }
        let fileName = "\(vehicleName)MaintenanceReport.pdf"
        
        // Get the path to the documents directory
        let fileURL = documentsDirectory?.appendingPathComponent(fileName)
        
        // Create a PDF renderer
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        // Render content to the PDF file
        let pdfData = pdfRenderer.pdfData { context in
            
            // Initialize the y-position (start after the headers)
            var yPosition: CGFloat = topMargin
            
            // Function to begin a new page
            func beginNewPage(isFirstPage: Bool) {
                context.beginPage()
                
                // Reset yPosition to start after the headers
                yPosition = topMargin
                
                // Draw headers for the first page
                if isFirstPage {
                    drawHeader(
                        context: context,
                        yPosition: &yPosition
                    )
                }
            }
            
            // Start the first page
            beginNewPage(isFirstPage: true)
            
            // Draw the content of the PDF
            let tableRowAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]
                        
            for (index, event) in events.enumerated() {
                // Check if yPosition is close to the bottom of the page and create a new page if necessary
                if yPosition + 60 > pageHeight - bottomMargin {  // 60 is the estimated height of one row
                    beginNewPage(isFirstPage: index == 0)
                }
                
                // Draw Date and Vehicle Name as single-line text
                event.date
                    .formatted()
                    .draw(
                        at: CGPoint(
                            x: leftMargin,
                            y: yPosition
                        ),
                        withAttributes: tableRowAttributes
                    )
                
                vehicleName
                    .draw(
                        at: CGPoint(
                            x: leftMargin + columnWidth,
                            y: yPosition
                        ),
                        withAttributes: tableRowAttributes
                    )
                
                // Draw Notes with text wrapping within a bounding rectangle
                let notesRect = CGRect(
                    x: leftMargin + 2 * columnWidth,
                    y: yPosition,
                    width: columnWidth - 20,
                    height: 50
                )
                event.notes.draw(in: notesRect, withAttributes: tableRowAttributes)
                
                // Adjust the spacing for the next row
                yPosition += 60
            }
        }
        
        // Save the PDF data to the file URL
        do {
            try pdfData.write(to: fileURL!)
            print("PDF saved to: \(fileURL!.path)")
            return fileURL
        } catch {
            print("Could not save the PDF: \(error)")
            return nil
        }
    }
    
    // Helper function to draw header
    private func drawHeader(
        context: UIGraphicsPDFRendererContext,
        yPosition: inout CGFloat
    ) {
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
        
        // Center the headers
        let titleX = (pageWidth - titleSize.width) / 2
        let vehicleX = (pageWidth - vehicleSize.width) / 2
        let eventTitleX = (pageWidth - eventTitleSize.width) / 2
        let dateRangeX = (pageWidth - dateRangeSize.width) / 2
        
        // Draw the main title centered
        titleString.draw(at: CGPoint(x: titleX, y: yPosition), withAttributes: titleAttributes)
        yPosition += 30
        
        // Draw the vehicle name centered
        vehicleName.draw(at: CGPoint(x: vehicleX, y: yPosition), withAttributes: subtitleAttributes)
        yPosition += 30
        
        // Draw the maintenance event title centered
        eventTitleString.draw(at: CGPoint(x: eventTitleX, y: yPosition), withAttributes: subtitleAttributes)
        yPosition += 30
        
        // Draw date range centered
        dateRangeString.draw(at: CGPoint(x: dateRangeX, y: yPosition), withAttributes: subtitleAttributes)
        yPosition += 50  // Add more space after the headers
        
        drawColumnsHeaders(yPosition: &yPosition)
    }
    
    private func drawColumnsHeaders(
        yPosition: inout CGFloat
    ) {
        // Draw the headers of each column
        let dateColumnHeader = "Date"
        let vehicleColumnHeader = "Vehicle Name"
        let noteColumnHeader = "Notes"
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        
        dateColumnHeader
            .draw(
                at: CGPoint(
                    x: leftMargin,
                    y: yPosition
                ),
                withAttributes: subtitleAttributes
            )
        
        vehicleColumnHeader
            .draw(
                at: CGPoint(
                    x: leftMargin + columnWidth,
                    y: yPosition
                ),
                withAttributes: subtitleAttributes
            )
        
        // Draw Notes with text wrapping within a bounding rectangle
        let notesRect = CGRect(
            x: leftMargin + 2 * columnWidth,
            y: yPosition,
            width: columnWidth - 20,
            height: 50
        )
        noteColumnHeader.draw(in: notesRect, withAttributes: subtitleAttributes)
        
        // Adjust the spacing for the next row
        yPosition += 30
    } 
}
