//
//  MockFirebaseService.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseFirestore
@testable import Basic_Car_Maintenance

class MockFirebaseService: FirebaseServiceProtocol {
    
    var readings: [OdometerReading] = [
        OdometerReading(id: "reading1", 
                        userID: "testUser1", 
                        date: Date.now, 
                        distance: 12500, 
                        isMetric: true, 
                        vehicleID: "LA8585"),
        OdometerReading(id: "reading2", 
                        userID: "testUser2", 
                        date: Date.now, 
                        distance: 56410, 
                        isMetric: true,
                        vehicleID: "SF2222"),
    ]
    
    var vehicles: [Vehicle] = []
    
    let newReading = 
        OdometerReading(id: "reading3", 
            userID: "testUser1", 
            date: Date.now, 
            distance: 138542, 
            isMetric: true, 
            vehicleID: "LV0000")
    
    let testVehicles = [
        Vehicle(
            id: "LA8585", 
            userID: "testUser1", 
            name: "Car1", 
            make: "Toyota", 
            model: "Corolla", 
            year: "2018", 
            color: "White", 
            vin: "VIN111", 
            licensePlateNumber: "PLATE1"),
        Vehicle(
            id: "SF2222", 
            userID: "testUser2", 
            name: "Car2", 
            make: "Lexus", 
            model: "RX", 
            year: "2021", 
            color: "Black", 
            vin: "VIN222", 
            licensePlateNumber: "PLATE2")
    ]
    
    func addReading(_ reading: OdometerReading) throws {
        readings.append(reading)
    }
    
    func deleteReading(reading: OdometerReading, documentId: String) async {
        readings.removeAll { $0.id == documentId }
    }
    
    func getReadings(userUID: String) async -> [OdometerReading] {
        let fetchedReadings = readings.filter { $0.userID == userUID }
        return fetchedReadings
    }
    
    func updateReading(reading: OdometerReading, documentId: String, userUID: String) throws {
        if let index = readings.firstIndex(where: { $0.id == documentId }) {
            var updatedReading = reading
            updatedReading.userID = userUID
            readings[index] = updatedReading
        }
    }
    
    func getVehicles(uid: String) async -> [Vehicle] {
        let fetchedVehicles = vehicles.filter { $0.userID == uid }
        return fetchedVehicles
    }
}
