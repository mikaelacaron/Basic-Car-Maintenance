//
//  OdometerViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable
class OdometerViewModel {
    
    let authenticationViewModel: AuthenticationViewModel
    
    var readings = [OdometerReading]()
    var showAddErrorAlert = false
    var showErrorAlert = false
    var isShowingAddOdometerReading = false
    var isShowingAddView = false
    var errorMessage: String = ""
    var vehicles = [Vehicle]()

    init(authenticationViewModel: AuthenticationViewModel) {
        self.authenticationViewModel = authenticationViewModel
    }
    
    func addReading(_ odometerReading: OdometerReading) {
        if let uid = authenticationViewModel.user?.uid {
            var readingToAdd = odometerReading
            readingToAdd.userID = uid
            
            do {
                let documentReference = try Firestore
                    .firestore()
                    .collection("odometer_readings")
                    .addDocument(from: readingToAdd)
                
                var reading = odometerReading
                
                readings.append(reading)
                
                errorMessage = ""
                isShowingAddOdometerReading = false
            } catch {
                showAddErrorAlert.toggle()
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func getOdometerReadings() async {
        if let uid = authenticationViewModel.user?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection(FirestoreCollection.odometerReadings)
                .whereField("userID", isEqualTo: uid)
            
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
