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
    var selectedVehicle: Vehicle?
    
    let firebaseService: FirebaseServiceProtocol
    init(userUID: String?, firebaseService: FirebaseServiceProtocol) {
        self.userUID = userUID
        self.firebaseService = firebaseService
    }
    
    func addReading(_ odometerReading: OdometerReading) throws {
        if let uid = userUID {
            var readingToAdd = odometerReading
            readingToAdd.userID = uid
            
            try firebaseService.addReading(readingToAdd)
            AnalyticsService.shared.logEvent(.odometerCreate)
        }
    }
    
    func deleteReading(_ reading: OdometerReading) async {
        if let eventIndex = readings.firstIndex(of: reading) {
            readings.remove(at: eventIndex)
            
            await firebaseService.deleteReading(reading)
            AnalyticsService.shared.logEvent(.odometerDelete)
        }
    }
    
    func getOdometerReadings() async {
        if let userUID = userUID {
            self.readings = await firebaseService.getReadings(userUID: userUID)   
        }
    }
    
    func updateOdometerReading(_ reading: OdometerReading) {
        if let uid = userUID {
            var readingToUpdate = reading
            readingToUpdate.userID = uid
        do {
            try firebaseService.updateReading(readingToUpdate)
            
            AnalyticsService.shared.logEvent(.odometerUpdate)
            
            isShowingEditReadingView = false
        } catch {
            errorMessage = error.localizedDescription
            showEditErrorAlert = true
        }
    }
}
    
    func getVehicles() async {
        if let userUID = userUID {
            self.vehicles = await firebaseService.getVehicles(userUID: userUID)
        }
    }
}
