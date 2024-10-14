//
//  BasicCarMaintenanceWidgetEntryView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseAuth
import SwiftUI
import WidgetKit

struct BasicCarMaintenanceWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        if Auth.auth().currentUser != nil {
            switch widgetFamily {
            case .systemMedium:
                MediumMaintenanceView(entry: entry)
            default:
                Text("Unimplemented widget family: \(widgetFamily.rawValue)")
            }
        } else {
            Text("Please sign in to use this widget.")
        }
    }
}
