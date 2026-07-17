//
//  ContributorsListView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct ContributorsListView: View {
    var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            if !viewModel.sortedContributors.isEmpty {
                ForEach(viewModel.sortedContributors) { contributor in
                    Link(destination: URL(string: contributor.htmlURL) ?? GitHubURL.repo) {
                        ContributorsProfileView(contributor: contributor)
                    }
                    .foregroundStyle(.primary)
                }
            } else {
                ProgressView()
            }
        }
        .analyticsView("\(Self.self)")
        .task {
            await viewModel.getContributors()
        }
        .navigationTitle("Contributors")
    }
}

#Preview {
    let viewModel = SettingsViewModel(authenticationViewModel: AuthenticationViewModel())
    return NavigationStack {
        ContributorsListView(viewModel: viewModel)
    }
}
