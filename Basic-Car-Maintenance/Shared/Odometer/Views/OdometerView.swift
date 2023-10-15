//
//  OdometerView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 10/11/23.
//

import SwiftUI

struct OdometerView: View {
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @Bindable private var viewModel: OdometerViewModel
    @State private var isShowingEditView = false
    @State private var isShowingAddView = false
    @State private var selectedOdometerReading: OdometerReading?
    
    init(authenticationViewModel: AuthenticationViewModel) {
        viewModel = OdometerViewModel(authenticationViewModel: authenticationViewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sortedReadings) { reading in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(reading.distance) \(reading.unitsAreMetric ? "Km" : "M")")
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
                            Image(systemName: "trash")
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
                        EditOdometerReadingDetailView(
                            selectedReading: $selectedOdometerReading, viewModel: viewModel)
                    }
                }
                .listStyle(.inset)
            }
            .overlay {
                if viewModel.readings.isEmpty {
                    Text("Add your first odometer")
                }
            }
            .animation(.linear, value: viewModel.sortOption)
            .navigationTitle(Text("Odometer"))
            .alert("Failed To Delete Reading", isPresented: $viewModel.showErrorAlert) {
                Button("OK") {
                    viewModel.showErrorAlert = false
                }
            } message: {
                Text(viewModel.errorMessage).padding()
            }
            .navigationDestination(isPresented: $viewModel.isShowingAddOdometerReading) {
                makeAddOdometerView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        viewModel.isShowingAddOdometerReading = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Menu {
                        Picker(selection: $viewModel.sortOption) {
                            ForEach(OdometerViewModel.SortOption.allCases) { option in
                                Text(option.label)
                                    .tag(option)
                            }
                        } label: {
                            EmptyView()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .task {
                await viewModel.getOdometerReadings()
                await viewModel.getVehicles()
            }
            .sheet(isPresented: $isShowingAddView) {
                makeAddOdometerView()
            }
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            guard case .active = newScenePhase else { return }
            
            guard let action = actionService.action,
                  action == .addOdometerReading
            else {
                // another action has been triggered, so we will need to dismiss the current presented view
                isShowingAddView = false
                return
            }
            
            // if the view is already presented, do nothing
            guard !isShowingAddView else { return }
            // delay the presentation of the view a bit
            // to make sure the already presented view is dismissed.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isShowingAddView = true
            }
        }
    }
    
    private func makeAddOdometerView() -> some View {
        AddOdometerReadingView(vehicles: viewModel.vehicles) { reading in
            viewModel.addReading(reading)
            Task {
                await viewModel.getOdometerReadings()
            }
        }
        .alert("An Error Occurred", isPresented: $viewModel.showAddErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    OdometerView(authenticationViewModel: AuthenticationViewModel())
        .environment(ActionService.shared)
}
