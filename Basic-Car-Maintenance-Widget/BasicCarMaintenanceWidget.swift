//
//  Basic-Car-Maintenance-Widget.swift
//  Basic-Car-Maintenance-Widget
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//
import Firebase
import FirebaseAuth
import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MaintenanceEventsCountEntry {
        return MaintenanceEventsCountEntry(
            date: Date(),
            configuration: .demo,
            maintenanceEventsCount: 0
        )
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MaintenanceEventsCountEntry {
        MaintenanceEventsCountEntry.demo
    }
    
    func timeline(for configuration: ConfigurationAppIntent,
                  in context: Context) async -> Timeline<MaintenanceEventsCountEntry> {
        var entries: [MaintenanceEventsCountEntry] = []
        
        let currentDate = Date()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let vehicleID = configuration.selectedVehicle?.id;
        let result = await DataService.fetchMaintenanceEventsCount(for: vehicleID)
        let entry = switch result {
        case .success(let maintenanceEventsCount):
            MaintenanceEventsCountEntry(date: currentDate, configuration: configuration, maintenanceEventsCount: maintenanceEventsCount)
        case .failure(let error): 
            MaintenanceEventsCountEntry(
                date: currentDate,
                configuration: configuration,
                error: error.localizedDescription
            )
        }
        
        entries.append(entry)
        
        
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }
}

struct MaintenanceEventsCountEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let maintenanceEventsCount: Int?
    let error: String?
    
    init(
        date: Date,
        configuration: ConfigurationAppIntent,
        maintenanceEventsCount: Int? = 0,
        error: String? = nil
    ) {
        self.date = date
        self.configuration = configuration
        self.maintenanceEventsCount = maintenanceEventsCount
        self.error = error
    }
}

struct BasicCarMaintenanceWidget: Widget {
    let kind: String = "BasicCarMaintenanceWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            BasicCarMaintenanceWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}


#Preview(as: .systemSmall) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEventsCountEntry.demo
}
