//
//  OdometerViewModel.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseFirestore
import Foundation

@Observable
class OdometerViewModel {
    
    private let userUID: String?
    @Published var readings: [OdometerReading] = []
    @Published var showAddErrorAlert = false
    @Published var isShowingAddOdometerReading = false
    @Published var errorMessage: String = ""
    @Published var showEditErrorAlert = false
    @Published var selectedReading: OdometerReading?
    @Published var isShowingEditReadingView = false
    @Published var vehicles: [Vehicle] = []
    
    private let db = Firestore.firestore()
    
    init(userUID: String?) {
        self.userUID = userUID
    }
    
    func addReading(_ odometerReading: OdometerReading) async {
        guard let uid = userUID else { return }
        
        var readingToAdd = odometerReading
        readingToAdd.userID = uid
        
        do {
            try await db.collection(FirestorePath.odometerReadings(vehicleID: readingToAdd.vehicleID).path)
                .addDocument(from: readingToAdd)
            
            AnalyticsService.shared.logEvent(.odometerCreate)
        } catch {
            errorMessage = error.localizedDescription
            showAddErrorAlert = true
        }
    }
    
    func deleteReading(_ reading: OdometerReading) async {
        guard let documentId = reading.id else {
            errorMessage = "Reading Entry has no document ID."
            showEditErrorAlert = true
            return
        }
        
        do {
            try await db.collection(FirestorePath.odometerReadings(vehicleID: reading.vehicleID).path)
                .document(documentId)
                .delete()
            
            readings.removeAll { $0.id == documentId }
            
            AnalyticsService.shared.logEvent(.odometerDelete)
        } catch {
            errorMessage = error.localizedDescription
            showEditErrorAlert = true
        }
    }
    
    func getOdometerReadings() async {
        guard let userUID = userUID else { return }
        
        do {
            let querySnapshot = try await db.collectionGroup(FirestoreCollection.odometerReadings)
                .whereField(FirestoreField.userID, isEqualTo: userUID)
                .getDocuments()
            
            self.readings = querySnapshot.documents.compactMap { try? $0.data(as: OdometerReading.self) }
        } catch {
            errorMessage = error.localizedDescription
            showAddErrorAlert = true
        }
    }
    
    func updateOdometerReading(_ reading: OdometerReading) async {
        guard let userUID = userUID, let id = reading.id else { return }
        
        var readingToUpdate = reading
        readingToUpdate.userID = userUID
        
        do {
            try await db.collection(FirestorePath.odometerReadings(vehicleID: readingToUpdate.vehicleID).path)
                .document(id)
                .setData(from: readingToUpdate)
            
            AnalyticsService.shared.logEvent(.odometerUpdate)
            isShowingEditReadingView = false
        } catch {
            errorMessage = error.localizedDescription
            showEditErrorAlert = true
        }
    }
    
    func getVehicles() async {
        guard let uid = userUID else { return }
        
        do {
            let querySnapshot = try await db.collection(FirestoreCollection.vehicles)
                .whereField(FirestoreField.userID, isEqualTo: uid)
                .getDocuments()
            
            self.vehicles = querySnapshot.documents.compactMap { try? $0.data(as: Vehicle.self) }
        } catch {
            errorMessage = error.localizedDescription
            showAddErrorAlert = true
        }
    }
}
