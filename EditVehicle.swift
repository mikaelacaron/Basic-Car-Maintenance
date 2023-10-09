//
//  EditVehicle.swift
//  Basic-Car-Maintenance
//
//  Created by Timothy Lewis on 10/8/23.
//

import Foundation
import Firebase

func updateVehicle(vehicleName: String) {
	let db = Firestore.firestore()

	let docRef = db.collection("Vehicle").document(vehicleName)

	docRef.updateData(["vehicles": vehicleName]) { error in
		if let error = error {
			print("Error updating document: \(error)")
		} else {
			print("Document successfully updated!")
		}
	}
}
