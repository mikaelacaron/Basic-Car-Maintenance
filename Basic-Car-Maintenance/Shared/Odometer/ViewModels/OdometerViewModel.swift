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
    
    let userUID: String?
    
    var readings = [OdometerReading]()
    var showAddErrorAlert = false
    var isShowingAddOdometerReading = false
    var errorMessage: String = ""
    
    var showEditErrorAlert = false
    var selectedReading: OdometerReading?
    var isShowingEditReadingView = false
    
    var vehicles = [Vehicle]()

    init(userUID: String?) {
        self.userUID = userUID
    }
    
    func addReading(_ reading: OdometerReading) throws {
        if let uid = userUID {
            var readingToAdd = reading
            readingToAdd.userID = uid
            
            try FirebaseService.shared.addReading(readingToAdd)
            AnalyticsService.shared.logEvent(.odometerCreate)
        }
    }
    
    func deleteReading(_ reading: OdometerReading) async {
        guard let documentId = reading.id else {
            fatalError("Reading Entry has no document ID.")
        }
        
        if let eventIndex = readings.firstIndex(of: reading) {
            readings.remove(at: eventIndex)
        }
        
        await FirebaseService.shared.deleteReading(reading: reading, documentId: documentId)
        AnalyticsService.shared.logEvent(.odometerDelete)
    }
        
    func getOdometerReadings() async {
        if let userUID = userUID {
            self.readings = await FirebaseService.shared.getReadings(userUID: userUID)   
        }
    }
    
    func updateOdometerReading(_ reading: OdometerReading) {
        
        if let userUID = userUID {
            guard let id = reading.id else { return }
            
            do {
                try FirebaseService.shared.updateReading(reading: reading, documentId: id, userUID: userUID)
                
                AnalyticsService.shared.logEvent(.odometerUpdate)
                
                isShowingEditReadingView = false
            } catch {
                errorMessage = error.localizedDescription
                showEditErrorAlert = true
            }
        }
    }
    
    func getVehicles() async {
        if let uid = userUID {
            self.vehicles = await FirebaseService.shared.getVehicles(uid: uid)
        }
    }
}
