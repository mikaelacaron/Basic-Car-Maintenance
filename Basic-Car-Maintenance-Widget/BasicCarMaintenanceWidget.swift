//
//  Basic-Car-Maintenance-Widget.swift
//  Basic-Car-Maintenance-Widget
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Firebase
import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MaintenanceEntry {
        MaintenanceEntry(
            date: Date(), 
            configuration: .demo,
            maintenanceEvents: .demo
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MaintenanceEntry {
        MaintenanceEntry(
            date: Date(), 
            configuration: configuration,
            maintenanceEvents: .demo
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent,
                  in context: Context) async -> Timeline<MaintenanceEntry> {
        let currentDate = Date()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        let result = await fetchMaintenanceEvents(for: configuration.selectedVehicle?.id)
        let entry = switch result {
        case .success(let events):
            MaintenanceEntry(date: currentDate, configuration: configuration, maintenanceEvents: events)
        case .failure(let error):
            // Returns an empty list of options
            MaintenanceEntry(date: currentDate, configuration: configuration, maintenanceEvents: [], error: error.localizedDescription)
        }
        
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    /// Fetches maintenance events for the selected vehicle from Firestore.
    /// - Parameter vehichleID: The ID of the selected vehicle.
    /// - Returns: A list of maintenance events or an error if the fetch fails.
    private func fetchMaintenanceEvents(for vehichleID: String?) async -> Result<[MaintenanceEvent], Error> {
        guard let vehichleID else {
            return .failure(FetchError.noVehicleSelected)
        }
        
        do {
            let docRef = Firestore.firestore().collection("\(FirestoreCollection.vehicles)/\(vehichleID)/\(FirestoreCollection.maintenanceEvents)")
            let snapshot = try await docRef.getDocuments()
            let events = snapshot.documents.compactMap {
                try? $0.data(as: MaintenanceEvent.self)
            }
            return .success(events)
        } catch {
            return .failure(error)
        }
    }
}
    
/// Errors that can occur when fetching maintenance events.
enum FetchError: LocalizedError {
    case noVehicleSelected
    
    var errorDescription: String {
        switch self {
        case .noVehicleSelected:
            "No vehicle selected. Please select a vehicle to continue."
        }
    }
}

struct MaintenanceEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let maintenanceEvents: [MaintenanceEvent]
    let error: String?
    
    init(date: Date, configuration: ConfigurationAppIntent, maintenanceEvents: [MaintenanceEvent], error: String? = nil) {
        self.date = date
        self.configuration = configuration
        self.maintenanceEvents = maintenanceEvents
        self.error = error
    }
}

struct BasicCarMaintenanceWidget: Widget {
    let kind: String = "BasicCarMaintenanceWidget"
    
    init() {
        FirebaseApp.configure()
        
        // TODO: Share app defaults
        let useEmulator = true // UserDefaults.standard.bool(forKey: "useEmulator")
        if useEmulator {
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
        }
    }

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            BasicCarMaintenanceWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemMedium) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEntry(date: .now, configuration: .demo, maintenanceEvents: .demo)
}
