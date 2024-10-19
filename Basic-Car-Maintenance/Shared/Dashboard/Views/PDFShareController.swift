//
//  PDFShareController.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import UIKit
import SwiftUI

struct PDFShareController: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        // For iPads, you need to specify the source of the activity view controller
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = context.coordinator.sourceView
            popoverController.sourceRect = CGRect(
                x: UIScreen.main.bounds.midX,
                y: UIScreen.main.bounds.midY,
                width: 0,
                height: 0
            )
            popoverController.permittedArrowDirections = []
        }
        
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
    
    class Coordinator: NSObject {
        var sourceView: UIView
        init(sourceView: UIView) {
            self.sourceView = sourceView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(sourceView: UIView())
    }
}
