//
//  DashboardView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct DashboardView: View {
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @State private var isShowingAddView = false
    @State private var viewModel: DashboardViewModel
    @State private var isShowingEditView = false
    @State private var selectedMaintenanceEvent: MaintenanceEvent?
    
    init(userUID: String?) {
        _viewModel = State(initialValue: DashboardViewModel(userUID: userUID))
    }

    private var noSearchResultsDescription: Text {
        Text("There were no maintenance events for '\(viewModel.searchText)'. Try a new search.",
             comment: "Text shown when there are no results for maintenance search")
        .accessibilityLabel("There were no maintenance events for '\(viewModel.searchText)'. Try a new search.") // swiftlint:disable:this line_length
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.searchedEvents) { event in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.title)
                            .font(.title3)
                        let vehicleName = viewModel.vehicles.first { $0.id == event.vehicleID }?.name
                        if let vehicleName {
                            Text("\(vehicleName) on \(event.date.toString())",
                                 comment: "Maintenance list item for a vehicle on a date")
                        }
                        if !event.notes.isEmpty {
                            Text(event.notes)
                                .lineLimit(0)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteEvent(event)
                            }
                        } label: {
                            VStack {
                                Text("Delete")
                                Image(systemName: SFSymbol.trash)
                            }
                        }

                        Button {
                            selectedMaintenanceEvent = event
                            isShowingEditView = true
                        } label: {
                            VStack {
                                Text("Edit", comment: "Button label to edit this maintenance")
                                Image(systemName: SFSymbol.pencil)
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingEditView) {
                        EditMaintenanceEventView(
                            selectedEvent: $selectedMaintenanceEvent, 
                            viewModel: viewModel
                        )
                    }
                    .accessibilityElement(children: .combine)
                }
                .listStyle(.inset)
            }
            .analyticsView("\(Self.self)")
            .searchable(text: $viewModel.searchText)
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    if viewModel.events.isEmpty {
                        Text("Add your first maintenance",
                             comment: "Placeholder text for empty maintenance list prompting the user to add a maintenance event") // swiftlint:disable:this line_length
                        .accessibilityLabel("Add your first maintenance.")
                    } else if viewModel.searchedEvents.isEmpty && !viewModel.searchText.isEmpty {
                        ContentUnavailableView("No results",
                                               systemImage: SFSymbol.magnifyingGlass,
                                               description: noSearchResultsDescription)
                    }
                }
            }
            .animation(.linear, value: viewModel.searchedEvents)
            .navigationTitle(
                Text("Dashboard", comment: "Title label for Dashboard view")
                    .accessibilityLabel("Dashboard")
            )
            .alert(
                Text("Failed To Delete Event", comment: "Title for alert shown when deleting maintenance event fails") // swiftlint:disable:this line_length
                    .accessibilityLabel("Failed to delete event."),
                isPresented: $viewModel.showErrorAlert
            ) {
                Button {
                    viewModel.showErrorAlert = false
                } label: {
                    Text("OK", comment: "Label to dismiss alert")
                        .accessibilityLabel("OK")
                }
                .accessibilityInputLabels(["Dismiss alert"])
            } message: {
                Text(viewModel.errorMessage)
                    .padding()
                    .accessibilityLabel(viewModel.errorMessage)
            }
            .navigationDestination(isPresented: $viewModel.isShowingAddMaintenanceEvent) {
                makeAddMaintenanceView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Menu {
                        Picker(selection: $viewModel.sortOption) {
                            ForEach(DashboardViewModel.SortOption.allCases) { option in
                                Text(option.label)
                                    .tag(option)
                            }
                        } label: {
                            EmptyView()
                        }
                    } label: {
                        Image(systemName: SFSymbol.filter)
                    }
                    .accessibilityShowsLargeContentViewer {
                        Label {
                            Text("Filter", comment: "Label for filtering on Dashboard view")
                                .accessibilityLabel("Filter.")
                        } icon: {
                            Image(systemName: SFSymbol.filter)
                        }
                    }
                    .accessibilityInputLabels(["Show filter"])

                    Button {
                        // TODO: Show Paywall
                        // Can only add 3 events, adding the 4th triggers the paywall
                        viewModel.isShowingAddMaintenanceEvent = true
                    } label: {
                        Image(systemName: SFSymbol.plus)
                    }
                    .accessibilityShowsLargeContentViewer {
                        Label {
                            Text("AddEvent", comment: "Label for adding maintenance event on Dashboard view")
                                .accessibilityLabel("Add an event.")
                        } icon: {
                            Image(systemName: SFSymbol.plus)
                        }
                    }
                    .accessibilityInputLabels(["Add event"])
                }
            }
            .task {
                await viewModel.getMaintenanceEvents()
                await viewModel.getVehicles()
            }
            .sheet(isPresented: $isShowingAddView) {
                makeAddMaintenanceView()
            }
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            guard case .active = newScenePhase else { return }
            
            // TODO: Show Paywall
            
            guard let action = actionService.action,
                  action == .newMaintenance
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
    
    private func makeAddMaintenanceView() -> some View {
        AddMaintenanceView(vehicles: viewModel.vehicles) { event in
            viewModel.addEvent(event)
            Task {
                await viewModel.getMaintenanceEvents()
            }
        }
        .alert(
            Text("An Error Occurred", comment: "Title for alert shown when adding maintenance event fails")
                .accessibilityLabel("An error occurred."),
            isPresented: $viewModel.showAddErrorAlert
        ) {
            Button(role: .cancel) {} label: {
                Text("OK", comment: "Label to dismiss alert")
                    .accessibilityLabel("OK")
            }
            .accessibilityInputLabels(["Dismiss"])
        } message: {
            Text(viewModel.errorMessage)
                .accessibilityLabel(viewModel.errorMessage)
        }
    }
}

#Preview {
    DashboardView(userUID: "")
        .environment(ActionService.shared)
}
