//
//  DashboardView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct DashboardView: View {
    @State private var isShowingAddView = false
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
            .animation(.linear, value: viewModel.sortedEvents)
            .navigationTitle(Text("Dashboard"))
            .sheet(isPresented: $isShowingAddView) {
                AddMaintenanceView() { event in
                    Task {
                        await viewModel.addEvent(event)
                    }
                    
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        isShowingAddView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Menu {
                        Picker(selection: $viewModel.sortOption, content: {
                            ForEach(DashboardViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.label)
                                    .tag(option.id)
                            }
                        }, label: { EmptyView() })
                    } label: {
                        Image(systemName: "ellipsis.circle")
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
