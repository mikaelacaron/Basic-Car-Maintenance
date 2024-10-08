//
//  BasicCarMaintenanceWidgetEntryView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI
import WidgetKit

struct BasicCarMaintenanceWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            MediumMaintenanceView(entry: entry)
        default:
            Text("Unimplemented widget family: \(widgetFamily.rawValue)")
        }
    }
}
