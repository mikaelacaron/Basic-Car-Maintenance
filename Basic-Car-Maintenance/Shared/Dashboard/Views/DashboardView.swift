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
    @Bindable private var viewModel: DashboardViewModel
    @State private var isShowingEditView = false
    @State private var selectedMaintenanceEvent: MaintenanceEvent?
    
    init(authenticationViewModel: AuthenticationViewModel) {
        viewModel = DashboardViewModel(authenticationViewModel: authenticationViewModel)
    }
    
    private var eventDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.searchedEvents) { event in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.title)
                            .font(.title3)
                        
                        Text("\(event.vehicle.name) on \(event.date, formatter: self.eventDateFormat)",
                             comment: "Maintenance list item for a vehicle on a date")
                        
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
                            Image(systemName: SFSymbol.trash)
                        }
                        
                        Button {
                            selectedMaintenanceEvent = event
                            isShowingEditView = true
                        } label: {
                            VStack {
                                Text("Edit",
                                     comment: "Button label to edit this maintenance")
                                Image(systemName: SFSymbol.pencil)
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingEditView) {
                        EditMaintenanceEventView(
                            selectedEvent: $selectedMaintenanceEvent, viewModel: viewModel)
                    }
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
                    } else if viewModel.searchedEvents.isEmpty && !viewModel.searchText.isEmpty {
                        ContentUnavailableView("No results",
                                               systemImage: SFSymbol.magnifyingGlass,
                                               description: noSearchResultsDescription)
                    }
                }
            }
            .animation(.linear, value: viewModel.searchedEvents)
            .navigationTitle(Text("Dashboard",
                                  comment: "Title label for Dashboard view"))
            .alert(Text("Failed To Delete Event",
                        comment: "Title for alert shown when deleting maintenance event fails"),
                   isPresented: $viewModel.showErrorAlert) {
                Button {
                    viewModel.showErrorAlert = false
                } label: {
                    Text("OK", comment: "Label to dismiss alert")
                }
            } message: {
                Text(viewModel.errorMessage).padding()
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
                        } icon: {
                            Image(systemName: SFSymbol.filter)
                        }
                    }
                    
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
                        } icon: {
                            Image(systemName: SFSymbol.plus)
                        }
                    }
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
        .alert(Text("An Error Occurred",
                    comment: "Title for alert shown when adding maintenance event fails"),
               isPresented: $viewModel.showAddErrorAlert) {
            Button(role: .cancel) {} label: {
                Text("OK", comment: "Label to dismiss alert")
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    private var noSearchResultsDescription: Text {
        Text("There were no maintenance events for '\(viewModel.searchText)'. Try a new search.",
             comment: "Text shwon when there are no results for maintenance search")
    }
}

#Preview {
    DashboardView(authenticationViewModel: AuthenticationViewModel())
        .environment(ActionService.shared)
}
