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
                ForEach(viewModel.events) { event in
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
            .navigationTitle(Text("Dashboard"))
            .sheet(isPresented: $isShowingAddView) {
                AddMaintenanceView() { event in
                    Task {
                        await viewModel.addEvent(event)
                    }
                    
                }
            }
            .alert("Failed To Delete Event", isPresented: $viewModel.showErrorAlert, actions: {
                Button("OK") {
                    viewModel.showErrorAlert = false
                }
            }, message: {
                Text(viewModel.errorMessage).padding()
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingAddView.toggle()
                    } label: {
                        Image(systemName: "plus")
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
