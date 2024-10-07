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
            configuration: ConfigurationAppIntent(),
            maintenanceEvents: [
                MaintenanceEvent(
                    vehicleID: "2014 Ford Focus", 
                    title: "Oil Change", 
                    date: .now, 
                    notes: "The cabin air filter was also replaced."
                )
            ]
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MaintenanceEntry {
        MaintenanceEntry(
            date: Date(), 
            configuration: configuration,
            maintenanceEvents: [
                MaintenanceEvent(
                    vehicleID: "2014 Ford Focus", 
                    title: "Oil Change", 
                    date: .now, 
                    notes: "The cabin air filter was also replaced."
                )
            ]
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent,
                  in context: Context) async -> Timeline<MaintenanceEntry> {
        let currentDate = Date()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        let result = await fetchFromDatabase(for: configuration.selectedVehicle?.id)
        let entry = switch result {
        case .success(let events):
            MaintenanceEntry(date: currentDate, configuration: configuration, maintenanceEvents: events)
        case .failure(let error):
            MaintenanceEntry(date: currentDate, configuration: configuration, maintenanceEvents: [], error: error.localizedDescription)
        }
        
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    func fetchFromDatabase(for vehichleID: String?) async -> Result<[MaintenanceEvent], Error> {
        // TODO: Add proper user id
        // TODO: Add vehicle id
        guard let userID = Optional("vb0owfUaNFxPHUTtGYN4jBo0fPdt") else {
            return .failure(FirestoreError.unauthenticated)
        }
        
        guard let vehichleID else {
            return .failure(FirestoreError.noVehicleSelected)
        }
        
        do {
            let docRef = Firestore
                            .firestore()
                            .collection("\(FirestoreCollection.vehicles)/\(vehichleID)/\(FirestoreCollection.maintenanceEvents)")
            
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
    
enum FirestoreError: LocalizedError {
    case unauthenticated
    case noVehicleSelected
    
    var errorDescription: String {
        switch self {
        case .unauthenticated:
            "User is not authenticated. Please sign in to the app to continue."
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

extension ConfigurationAppIntent {
    fileprivate static var demo: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedVehicle = MaintenanceVehicleAppEntity(id: "", displayString: "Kia Soul")
        return intent
    }
}

#Preview(as: .systemMedium) {
    BasicCarMaintenanceWidget()
} timeline: {
    MaintenanceEntry(date: .now, configuration: .demo, maintenanceEvents: [
        MaintenanceEvent(vehicleID: "", title: "Oil Change", date: .now, notes: "Test Notes"),
        MaintenanceEvent(vehicleID: "", title: "Oil Change", date: .now, notes: "Test Notes")
    ])
}
