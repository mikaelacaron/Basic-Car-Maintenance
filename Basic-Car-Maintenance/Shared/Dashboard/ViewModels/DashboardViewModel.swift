//
//  DashboardViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/3/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    let authenticationViewModel: AuthenticationViewModel
    
    @Published var events = [MaintenanceEvent]()
    @Published var showAddErrorAlert = false
    @Published var showErrorAlert = false
    @Published var isShowingAddMaintenanceEvent = false
    @Published var errorMessage : String = ""
    @Published var sortOption: SortOption = .custom
    
    var sortedEvents: [MaintenanceEvent] {
        switch sortOption {
        case .oldestToNewest: events.sorted { $0.date < $1.date }
        case .newestToOldest: events.sorted { $0.date > $1.date }
        case .custom: events
        }
    }
    
    init(authenticationViewModel: AuthenticationViewModel) {
        self.authenticationViewModel = authenticationViewModel
    }
    
    func addEvent(_ maintenanceEvent: MaintenanceEvent) async {
        if let uid = authenticationViewModel.user?.uid {
            var eventToAdd = maintenanceEvent
            eventToAdd.userID = uid
            
            do {
                let documentReference = try Firestore
                    .firestore()
                    .collection("maintenance_events")
                    .addDocument(from: eventToAdd)
                
                var event = maintenanceEvent
                let documentId = documentReference.documentID
                event.id = documentId
                
                events.append(event)
                
                errorMessage = ""
                isShowingAddMaintenanceEvent = false
            } catch {
                showAddErrorAlert.toggle()
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func getMaintenanceEvents() async {
        if let uid = authenticationViewModel.user?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection("maintenance_events").whereField("userID", isEqualTo: uid)
            
            let querySnapshot = try? await docRef.getDocuments()
            
            var events = [MaintenanceEvent]()
            
            if let querySnapshot {
                for document in querySnapshot.documents {
                    if let event = try? document.data(as: MaintenanceEvent.self) {
                        events.append(event)
                    }
                }
                self.events = events
            }
        }
    }
    
    func deleteEvent(_ event: MaintenanceEvent) async {
        guard let documentId = event.id else {
            fatalError("Event \(event.title) has no document ID.")
        }
        
        do {
            try await Firestore
                .firestore()
                .collection("maintenance_events")
                .document(documentId)
                .delete()
            errorMessage = ""
        } catch {
            showErrorAlert.toggle()
            errorMessage = error.localizedDescription
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
            case .oldestToNewest: "Oldest to Newest"
            case .newestToOldest: "Newest to Oldest"
            case .custom: "Custom"
            }
        }
    }
}
