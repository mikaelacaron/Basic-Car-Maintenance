//
//  DashboardViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/3/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@Observable
class DashboardViewModel {
    
    let authenticationViewModel: AuthenticationViewModel
    
    var events = [MaintenanceEvent]()
    var showAddErrorAlert = false
    var showErrorAlert = false
    var isShowingAddMaintenanceEvent = false
    var errorMessage: String = ""
    var sortOption: SortOption = .custom
    var vehicles = [Vehicle]()
    var searchText: String = ""
    var fetchingMaintenanceEvents = false

    var sortedEvents: [MaintenanceEvent] {
        switch sortOption {
        case .oldestToNewest: events.sorted { $0.date < $1.date }
        case .newestToOldest: events.sorted { $0.date > $1.date }
        case .custom: events
        }
    }
    
    var searchedEvents: [MaintenanceEvent] {
        if searchText.isEmpty {
            sortedEvents
        } else {
            sortedEvents.filter { $0.title.localizedStandardContains(searchText) }
        }
    }
    
    init(authenticationViewModel: AuthenticationViewModel) {
        self.authenticationViewModel = authenticationViewModel
    }
    
    func addEvent(_ maintenanceEvent: MaintenanceEvent) {
        if let uid = authenticationViewModel.user?.uid {
            var eventToAdd = maintenanceEvent
            eventToAdd.userID = uid
            
            do {
                try Firestore
                    .firestore()
                    .collection(FirestoreCollection.maintenanceEvents)
                    .addDocument(from: eventToAdd)
                
                events.append(maintenanceEvent)
                
                errorMessage = ""
                isShowingAddMaintenanceEvent = false
            } catch {
                showAddErrorAlert.toggle()
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func getMaintenanceEvents() async {
        fetchingMaintenanceEvents = true

        if let uid = authenticationViewModel.user?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection(FirestoreCollection.maintenanceEvents)
                .whereField(FirestoreField.userID, isEqualTo: uid)
            
            let querySnapshot = try? await docRef.getDocuments()
            
            var events = [MaintenanceEvent]()
            
            if let querySnapshot {
                for document in querySnapshot.documents {
                    if let event = try? document.data(as: MaintenanceEvent.self) {
                        events.append(event)
                    }
                }
                self.fetchingMaintenanceEvents = false
                self.events = events
            }
        }
    }
    
    func updateEvent(_ maintenanceEvent: MaintenanceEvent) async {
        
        if let uid = authenticationViewModel.user?.uid {
            guard let id = maintenanceEvent.id else { return }
            var eventToUpdate = maintenanceEvent
            eventToUpdate.userID = uid
            do {
                try Firestore
                    .firestore()
                    .collection(FirestoreCollection.maintenanceEvents)
                    .document(id)
                    .setData(from: eventToUpdate)
            } catch {
                showAddErrorAlert.toggle()
                errorMessage = error.localizedDescription
            }
        }
        await self.getMaintenanceEvents()
    }
    
    func deleteEvent(_ event: MaintenanceEvent) async {
        guard let documentId = event.id else {
            fatalError("Event \(event.title) has no document ID.")
        }
        
        do {
            try await Firestore
                .firestore()
                .collection(FirestoreCollection.maintenanceEvents)
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
    }
    
    /// Fetches the user's vehicles from Firestore based on their unique user ID.
    func getVehicles() async {
        if let uid = authenticationViewModel.user?.uid {
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
