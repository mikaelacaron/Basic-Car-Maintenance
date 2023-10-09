//
//  EditVehicleView.swift
//  Basic-Car-Maintenance
//
//  Created by Timothy Lewis on 10/7/23.
//

//
//  EditVehicleDetailsView.swift
//  Basic-Car-Maintenance
//
//  Created by Timothy Lewis on 10/4/23.
//

import SwiftUI

struct EditVehicleView: View {

	let editTapped: (Vehicle) -> Void

	@State private var name = ""
	@State private var make = ""
	@State private var model = ""
	private var isVehicleValid: Bool {
		!name.isEmpty && !make.isEmpty && !model.isEmpty
	}

	@Environment(\.dismiss) var dismiss

	var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Name")) {
					TextField("Vehicle Name", text: $name, prompt: Text("Vehicle Name"))
				}
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
					Section(header: Text("Make")) {
						TextField("Vehicle Make", text: $make, prompt: Text("Vehicle Make"))
					}
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
					Section(header: Text("Model")) {
						TextField("Vehicle Model", text: $model, prompt: Text("Vehicle Model"))
					}
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
						}
					}
					.toolbar {
						ToolbarItemGroup(placement: .primaryAction) {
							Button {
								let vehicle = Vehicle(name: name, make: make, model: model)
								editTapped(vehicle)
								dismiss()

							} label: {
								Image(systemName: "pencil.circle.fill")
								Text("Edit")
							}
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
							}
							.disabled(!isVehicleValid)
						}
					}
				}
			}
		}
	}
}
#Preview {
	EditVehicleView()  { _ in }

}
