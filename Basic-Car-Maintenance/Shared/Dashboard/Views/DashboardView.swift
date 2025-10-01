//
//  DashboardView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct DashboardView: View {
    @Environment(ActionService.self) var actionService
    @Environment(\.scenePhase) var scenePhase
    @State private var isShowingAddView = false
    @State private var viewModel: DashboardViewModel
    @State private var isShowingEditView = false
    @State private var isShowingExportOptionsView = false
    @State private var isShowingVehicleSelection = false
    @State private var selectedMaintenanceEvent: MaintenanceEvent?
    
    init(userUID: String?) {
        _viewModel = State(initialValue: DashboardViewModel(userUID: userUID))
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
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        Text(event.date, formatter: self.eventDateFormat)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        let vehicleName = viewModel.vehicles.first { $0.id == event.vehicleID }?.name
                        if let vehicleName {
                            Text("For: \(vehicleName)", comment: "the vehcile name is filled in here")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        if !event.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Notes:")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.tertiary)
                                Text(event.notes)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.quaternary, lineWidth: 0.5)
                            }
                    }
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width * 0.95
                    }
                    .accessibilityElement(children: .combine)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteEvent(event)
                            }
                        } label: {
                            Image(systemName: SFSymbol.trash)
                        }
                        .tint(.red.opacity(0.8))
                        
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
                        .tint(.blue.opacity(0.8))
                    }
                    .sheet(isPresented: $isShowingEditView) {
                        EditMaintenanceEventView(
                            selectedEvent: $selectedMaintenanceEvent, viewModel: viewModel)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                }
            }
            .listStyle(.plain)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
            .analyticsView("\(Self.self)")
            .searchable(
                text: $viewModel.searchText,
                prompt: Text("Search", comment: "Prompt to search maintenance events")
            )
            .overlay {
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(24)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                } else {
                    if viewModel.events.isEmpty {
                        ContentUnavailableView(
                            "Tap the + to begin",
                            systemImage: "wrench",
                            description: Text("Add your first maintenance")
                        )
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.regularMaterial)
                                .frame(width: 300, height: 200)
                        }
                    } else if viewModel.sortedEvents.isEmpty && viewModel.sortOption == .byVehicle {
                        ContentUnavailableView(
                            "No Results",
                            systemImage: SFSymbol.magnifyingGlass,
                            description: Text("No maintenance events found for the selected vehicle.")
                        )
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.regularMaterial)
                                .frame(width: 300, height: 200)
                        }
                    } else if viewModel.searchedEvents.isEmpty && !viewModel.searchText.isEmpty {
                        ContentUnavailableView("No results",
                                               systemImage: SFSymbol.magnifyingGlass,
                                               description: noSearchResultsDescription)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.regularMaterial)
                                .frame(width: 300, height: 200)
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.searchedEvents)
            .navigationTitle(Text("Dashboard",
                                comment: "Navigation title for the dashboard screen"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !viewModel.events.isEmpty {
                        Menu {
                            Button {
                                isShowingExportOptionsView = true
                            } label: {
                                Label("Export", systemImage: SFSymbol.squareAndArrowUp)
                            }
                            
                            Button {
                                isShowingVehicleSelection = true
                            } label: {
                                Label("Sort", systemImage: SFSymbol.lineHorizontal3DecreaseCircle)
                            }
                        } label: {
                            Image(systemName: SFSymbol.ellipsisCircle)
                                .foregroundStyle(.primary)
                        }
                        .background {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 32, height: 32)
                        }
                    }
                    
                    Button {
                        isShowingAddView = true
                    } label: {
                        Image(systemName: SFSymbol.plus)
                            .fontWeight(.semibold)
                    }
                    .background {
                        Circle()
                            .fill(.regularMaterial)
                            .frame(width: 32, height: 32)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddView) {
            AddMaintenanceEventView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingExportOptionsView) {
            ExportOptionsView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingVehicleSelection) {
            VehicleSelectionView(viewModel: viewModel)
        }
        .task {
            await viewModel.getMaintenanceEvents()
            await viewModel.getVehicles()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.getMaintenanceEvents()
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .alert("Error Adding Event", isPresented: $viewModel.showAddErrorAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    private var noSearchResultsDescription: Text {
        Text("Try searching for something else or check your spelling.", 
             comment: "Description when no search results are found")
    }
}

#Preview("Dashboard with events") {
    @Previewable @State var actionService = ActionService()
    DashboardView(userUID: "test")
        .environment(actionService)
}

#Preview("Dashboard no events") {
    @Previewable @State var actionService = ActionService()
    let viewModel = DashboardViewModel(userUID: "test")
    viewModel.isLoading = false
    
    return DashboardView(userUID: "test")
        .environment(actionService)
}
