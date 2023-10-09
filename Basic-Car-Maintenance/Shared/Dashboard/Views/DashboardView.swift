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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sortedEvents) { event in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.title)
                            .font(.title3)
                        
                        Text("\(event.date.formatted(date: .abbreviated, time: .omitted))")
                        
                        Text(event.notes)
                            .lineLimit(0)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteEvent(event)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                        Button {
                            selectedMaintenanceEvent = event
                            isShowingEditView = true
                        } label: {
                            VStack {
                                Text("Edit")
                                Image(systemName: "pencil")
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
            .overlay {
                if viewModel.events.isEmpty {
                    Text("Add your first maintenance")
                }
            }
            .animation(.linear, value: viewModel.sortOption)
            .navigationTitle(Text("Dashboard"))
            .alert("Failed To Delete Event", isPresented: $viewModel.showErrorAlert) {
                Button("OK") {
                    viewModel.showErrorAlert = false
                }
            } message: {
                Text(viewModel.errorMessage).padding()
            }
            .navigationDestination(isPresented: $viewModel.isShowingAddMaintenanceEvent) {
                makeAddMaintenanceView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        viewModel.isShowingAddMaintenanceEvent = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    
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
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .task {
                await viewModel.getMaintenanceEvents()
            }
            .sheet(isPresented: $isShowingAddView) {
                makeAddMaintenanceView()
            }
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            guard case .active = newScenePhase else { return }
            
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
        AddMaintenanceView { event in
            viewModel.addEvent(event)
        }
        .alert("An Error Occurred", isPresented: $viewModel.showAddErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    DashboardView(authenticationViewModel: AuthenticationViewModel())
}
