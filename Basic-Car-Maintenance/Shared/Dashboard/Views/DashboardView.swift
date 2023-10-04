//
//  DashboardView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var isShowingAddView = false
    @State private var viewModel: DashboardViewModel
    
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
            .sheet(isPresented: $isShowingAddView) {
                AddMaintenanceView() { event in
                   viewModel.addEvent(event)
                }
            }
            .alert("Failed To Delete Event", isPresented: $viewModel.showErrorAlert) {
                Button("OK") {
                    viewModel.showErrorAlert = false
                }
            } message: {
                Text(viewModel.errorMessage).padding()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        isShowingAddView.toggle()
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
