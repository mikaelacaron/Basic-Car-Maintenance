//
//  OdometerView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    
    @State private var viewModel: OdometerViewModel

    init(userUID: String?) {
        self.init(viewModel: OdometerViewModel(userUID: userUID))
    }
    
    fileprivate init(viewModel: OdometerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.readings) { reading in
                    let vehicleName = viewModel.vehicles.first { $0.id == reading.vehicleID }?.name
                    OdometerRowView(reading: reading, vehicleName: vehicleName)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteReading(reading)
                                }
                            } label: {
                                Image(systemName: SFSymbol.trash)
                            }
                            
                            Button {
                                viewModel.selectedReading = reading
                                viewModel.isShowingEditReadingView = true
                            } label: {
                                Label {
                                    Text("Edit")
                                } icon: {
                                    Image(systemName: SFSymbol.pencil)
                                }
                            }
                        }
                }
                .listStyle(.inset)
            }
            .overlay {
                if viewModel.readings.isEmpty {
                    Text("Add your first odometer",
                         comment: "Placeholder text for empty odometer reading list")
                }
            }
            .navigationTitle(Text("Odometer"))
            .navigationDestination(isPresented: $viewModel.isShowingAddOdometerReading) {
                makeAddOdometerView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        viewModel.isShowingAddOdometerReading = true
                    } label: {
                        Image(systemName: SFSymbol.plus)
                    }
                }
            }
            .task {
                await viewModel.getOdometerReadings()
                await viewModel.getVehicles()
            }
            .sheet(isPresented: $viewModel.isShowingEditReadingView) {
                if let selectedReading = viewModel.selectedReading {
                    // swiftlint:disable:next line_length
                    EditOdometerReadingView(selectedReading: selectedReading, vehicles: viewModel.vehicles) { updatedReading in
                        viewModel.updateOdometerReading(updatedReading)
                    }
                    .alert("An Error Occurred", isPresented: $viewModel.showEditErrorAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(viewModel.errorMessage)
                    }
                }
            }

        }
        .analyticsView("\(Self.self)")
    }
    
    private func makeAddOdometerView() -> some View {
        AddOdometerReadingView(vehicles: viewModel.vehicles) { reading in
            do {
                try viewModel.addReading(reading)
                viewModel.isShowingAddOdometerReading = false
                Task {
                    await viewModel.getOdometerReadings()
                }
            } catch {
                viewModel.errorMessage = error.localizedDescription
                viewModel.showAddErrorAlert = true
            }
        }
        .alert("An Error Occurred", isPresented: $viewModel.showAddErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    var viewModel = OdometerViewModel(userUID: nil)
    let firstCar = createVehicle(id: "id1", name: "My 1st car")
    viewModel.vehicles.append(firstCar)

    let secondCar = createVehicle(id: "id2", name: "2nd Car")
    viewModel.vehicles.append(secondCar)
    
    let firstReading = createReading(vehicleID: secondCar.id!,
                                     date: "2024/10/18",
                                     distance: 20)
    viewModel.readings.append(firstReading)
    
    let secondReading = createReading(vehicleID: firstCar.id!,
                                     date: "2024/10/15",
                                     distance: 1000)
    viewModel.readings.append(secondReading)
    
    let thirdReading = createReading(vehicleID: firstCar.id!,
                                     date: "2024/10/13",
                                     distance: 10)
    viewModel.readings.append(thirdReading)

    return OdometerView(viewModel: viewModel)
        .environment(ActionService.shared)
}

private func createVehicle(id: String, name: String) -> Vehicle {
    Vehicle(id: id, 
            userID: nil, 
            name: name, 
            make: "", 
            model: "", 
            year: nil, 
            color: nil, 
            vin: nil, 
            licensePlateNumber: nil)
}

private func createReading(vehicleID: String, date: String, distance: Int) -> OdometerReading {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let firstDate = formatter.date(from: date)!
    return OdometerReading(id: UUID().uuidString,
                           userID: "", 
                           date: firstDate, 
                           distance: distance, 
                           isMetric: false, 
                           vehicleID: vehicleID)
}
