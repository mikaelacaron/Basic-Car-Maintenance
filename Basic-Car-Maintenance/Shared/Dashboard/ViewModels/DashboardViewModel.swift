//
//  DashboardViewModel.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@Observable
class DashboardViewModel {
    
    let userUID: String?
    
    var events = [MaintenanceEvent]()
    var showAddErrorAlert = false
    var showErrorAlert = false
    var isShowingAddMaintenanceEvent = false
    var errorMessage: String = ""
    var sortOption: SortOption = .custom
    var vehicles = [Vehicle]()
    var searchText: String = ""
    var isLoading = false

    var sortedEvents: [MaintenanceEvent] {
        switch sortOption {
        case .oldestToNewest: events.sorted { $0.date < $1.date }
        case .newestToOldest: events.sorted { $0.date > $1.date }
        case .custom: events
        }
    }
    
    var vehiclesWithSortedEventsDict: [Vehicle: [MaintenanceEvent]] {
        vehicles.reduce(into: [Vehicle: [MaintenanceEvent]]()) { result, currentVehicle in
            result[currentVehicle] = events
                .filter { $0.vehicleID == currentVehicle.id }
                .sorted(by: { $0.date < $1.date })
        }
    }
    
    var searchedEvents: [MaintenanceEvent] {
        if searchText.isEmpty {
            sortedEvents
        } else {
            sortedEvents.filter { $0.title.localizedStandardContains(searchText) }
        }
    }
    
    init(userUID: String?) {
        self.userUID = userUID
    }
    
    /// Adding a `MaintenanceEvent` in Firestore at:
    /// `vehicles/{vehicleDocumentID}/maintenance_events/{maintenceEventDocumentID}`
    /// - Parameter maintenanceEvent: The `MaintenanceEvent` to save
    func addEvent(_ maintenanceEvent: MaintenanceEvent) {
        if let uid = userUID {
            var eventToAdd = maintenanceEvent
            eventToAdd.userID = uid
            
            do {
                try Firestore
                    .firestore()
                    .collection(FirestorePath.maintenanceEvents(vehicleID: eventToAdd.vehicleID).path)
                    .addDocument(from: eventToAdd)
                
                events.append(maintenanceEvent)
                AnalyticsService.shared.logEvent(.maintenanceCreate)
                
                errorMessage = ""
                isShowingAddMaintenanceEvent = false
            } catch {
                showAddErrorAlert.toggle()
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func getMaintenanceEvents() async {
        isLoading = true

        if let userUID = userUID {
            let db = Firestore.firestore()
            do {
                let docRef = db.collectionGroup(FirestoreCollection.maintenanceEvents)
                    .whereField(FirestoreField.userID, isEqualTo: userUID)
                
                let querySnapshot = try await docRef.getDocuments()
                
                var events = [MaintenanceEvent]()
                
                for document in querySnapshot.documents {
                    if let event = try? document.data(as: MaintenanceEvent.self) {
                        events.append(event)
                    }
                }
                self.isLoading = false
                self.events = events
            } catch {
                self.isLoading = false
            }
        }
    }
    
    func updateEvent(_ maintenanceEvent: MaintenanceEvent) async {
        
        if let uid = userUID {
            guard let id = maintenanceEvent.id else { return }
            var eventToUpdate = maintenanceEvent
            eventToUpdate.userID = uid
            
            do {
                try Firestore
                    .firestore()
                    .collection(FirestorePath.maintenanceEvents(vehicleID: eventToUpdate.vehicleID).path)
                    .document(id)
                    .setData(from: eventToUpdate)
            } catch {
                showAddErrorAlert.toggle()
                errorMessage = error.localizedDescription
            }
        }
        
        AnalyticsService.shared.logEvent(.maintenanceUpdate)
        
        await self.getMaintenanceEvents()
    }
    
    func deleteEvent(_ event: MaintenanceEvent) async {
        guard let documentId = event.id else {
            fatalError("Event \(event.title) has no document ID.")
        }
        
        do {
            try await Firestore
                .firestore()
                .collection(FirestorePath.maintenanceEvents(vehicleID: event.vehicleID).path)
                .document(documentId)
                .delete()
            errorMessage = ""
            
            if let eventIndex = events.firstIndex(of: event) {
                events.remove(at: eventIndex)
            }
        } catch {
            showErrorAlert.toggle()
            errorMessage = error.localizedDescription
        }
        
        AnalyticsService.shared.logEvent(.maintenanceDelete)
    }
    
    /// Fetches the user's vehicles from Firestore based on their unique user ID.
    func getVehicles() async {
        if let uid = userUID {
            let db = Firestore.firestore()
            let docRef = db.collection("vehicles").whereField("userID", isEqualTo: uid)
            
            let querySnapshot = try? await docRef.getDocuments()
            
            var vehicles = [Vehicle]()
            
            if let querySnapshot {
                for document in querySnapshot.documents {
                    if let vehicle = try? document.data(as: Vehicle.self) {
                        vehicles.append(vehicle)
                    }
                }
                
                self.vehicles = vehicles
            }
        }
    }
}

// MARK: - Sort Option
extension DashboardViewModel {
    enum SortOption: Int, CaseIterable, Identifiable {
        case oldestToNewest = 0
        case newestToOldest = 1
        case custom = 2
        
        var id: Int {
            rawValue
        }
        
        var label: LocalizedStringResource {
            switch self {
            case .oldestToNewest:
                LocalizedStringResource(
                    "Oldest to Newest",
                    comment: "Sorting option that displays older items first.")
            case .newestToOldest:
                LocalizedStringResource(
                    "Newest to Oldest",
                    comment: "Sorting option that displays newer items first.")
            case .custom:
                LocalizedStringResource(
                    "Custom",
                    comment: "Sorting option that sorts items according to the user's preferences.")
            }
        }
    }
}
