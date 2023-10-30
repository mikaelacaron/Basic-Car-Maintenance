//
//  OdometerViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@Observable
final class OdometerViewModel: ObservableObject {
    var readings = [OdometerReading]()
    var showAddErrorAlert = false
    var isShowingAddOdometerReading = false
    var errorMessage: String = ""
    
    func addReading(_ odometerReading: OdometerReading) throws {
        if let uid = AppDefaults.getUserID() {
            var readingToAdd = odometerReading
            readingToAdd.userID = uid
            
            _ = try Firestore
                .firestore()
                .collection("odometer_readings")
                .addDocument(from: readingToAdd)
        }
    }
    
    func getOdometerReadings() async {
        if let uid = AppDefaults.getUserID() {
            let db = Firestore.firestore()
            let docRef = db.collection(FirestoreCollection.odometerReadings)
                .whereField(FirestoreField.userID, isEqualTo: uid)
            
            let querySnapshot = try? await docRef.getDocuments()
            
            var readings = [OdometerReading]()
            
            if let querySnapshot {
                for document in querySnapshot.documents {
                    if let reading = try? document.data(as: OdometerReading.self) {
                        readings.append(reading)
                    }
                }
                
                self.readings = readings
            }
        }
    }
}
