//
//  ContributorsListView.swift
//  Basic-Car-Maintenance
//
//  Created by Yashraj jadhav on 01/10/23.
//

import SwiftUI

struct ContributorsListView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            if let contributors = viewModel.contributors, !contributors.isEmpty {
                ForEach(contributors) { contributor in
                    Link(
                        destination: URL(string: contributor.htmlURL) ??
                        viewModel.urls["Basic-Car-Maintenance"]!) {
                            ContributorsProfileView(name: contributor.login, url: contributor.avatarURL)
                        }
                }
            } else {
                ProgressView() {
                }
            }
        }
        .task {
            Task {
                await viewModel.getContributors()
            }
        }
        .navigationTitle("Contributors")
    }
}
#Preview {
    let viewModel = SettingsViewModel(authenticationViewModel: AuthenticationViewModel())
    return ContributorsListView(viewModel: viewModel)
}
