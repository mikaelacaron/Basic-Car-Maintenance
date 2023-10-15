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
    var errorMessage: String = ""
    var sortOption: SortOption = .custom
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
                let documentId = documentReference.documentID
                reading.id = documentId
                
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
            let docRef = db.collection("odometer_readings").whereField("userID", isEqualTo: uid)
            
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

extension OdometerViewModel {
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
