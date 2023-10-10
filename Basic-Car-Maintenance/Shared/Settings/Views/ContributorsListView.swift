//
//  ContributorsListView.swift
//  Basic-Car-Maintenance
//
//  Created by Yashraj jadhav on 01/10/23.
//

import SwiftUI

struct ContributorsListView: View {
    
    var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            if let contributors = viewModel.contributors, !contributors.isEmpty {
                let sortedContributors = contributors.sorted { (contributor1, contributor2) in
                    
                    // Sort by contributions (highest first), then by login name
                    if contributor1.contributions > contributor2.contributions {
                        return true
                    } else if contributor1.contributions < contributor2.contributions {
                        return false
                    }
                    
                    // If contributions are equal, compare by login name
                    return contributor1.login < contributor2.login
                }
                
                ForEach(sortedContributors) { contributor in
                    Link(
                        destination: URL(string: contributor.htmlURL) ??
                        viewModel.urls["Basic-Car-Maintenance"]!) {
                            ContributorsProfileView(name: contributor.login, url: contributor.avatarURL)
                        }
                }
            } else {
                ProgressView()
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
