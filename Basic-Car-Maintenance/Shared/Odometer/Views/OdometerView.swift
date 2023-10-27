//
//  OdometerView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 10/11/23.
//

import SwiftUI

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    
    @State private var viewModel: OdometerViewModel
    @State private var isShowingEditView = false
    @State private var selectedOdometerReading: OdometerReading?

    init(authenticationViewModel: AuthenticationViewModel) {
        _viewModel = State(initialValue: OdometerViewModel(authenticationViewModel: authenticationViewModel))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.readings) { reading in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(reading.distance) \(reading.isMetric ? "km" : "mi")")
                            .font(.title3)
                        
                        Text("For \(reading.vehicle.name)")
                        
                        Text("\(reading.date.formatted(date: .abbreviated, time: .omitted))")
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteReading(reading)
                            }
                        } label: {
                            Image(systemName: SFSymbol.trash)
                        }
                        Button {
                            selectedOdometerReading = reading
                            isShowingEditView = true
                        } label: {
                            VStack {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }
                        }
                    }
                .sheet(isPresented: $isShowingEditView) {
                    EditOdometerReadingView(selectedOdometerReading: $selectedOdometerReading, viewModel: viewModel)
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
        }
        .analyticsView()
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
    OdometerView(authenticationViewModel: AuthenticationViewModel())
        .environment(ActionService.shared)
}
