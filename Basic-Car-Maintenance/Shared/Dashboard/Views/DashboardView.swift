//
//  DashboardView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var viewModel: DashboardViewModel
    
    init(authenticationViewModel: AuthenticationViewModel) {
        self._viewModel = StateObject(wrappedValue: DashboardViewModel(authenticationViewModel: authenticationViewModel)) // swiftlint:disable:this line_length
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
                AddMaintenanceView { event in
                    Task {
                        await viewModel.addEvent(event)
                    }
                }
                .alert("An Error Occurred", isPresented: $viewModel.showAddErrorAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage)
                }
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
        }
    }
}

#Preview {
    DashboardView(authenticationViewModel: AuthenticationViewModel())
}
