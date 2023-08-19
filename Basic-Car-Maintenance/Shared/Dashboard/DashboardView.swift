//
//  DashboardView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/19/23.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var isShowingAddView = false
    
    var body: some View {
        NavigationStack {
            Text("Dashboard")
                .sheet(isPresented: $isShowingAddView) {
                    AddMaintenanceView()
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isShowingAddView.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }
}

#Preview {
    DashboardView()
}
