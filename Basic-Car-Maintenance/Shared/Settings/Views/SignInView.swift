//
//  SignInView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/25/23.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("Email", text: $viewModel.email)
                
                SecureField("Password", text: $viewModel.password)
            }
            
            Section {
                if viewModel.user?.isAnonymous != nil {
                    Text("Logged in anonymously with ID: \(viewModel.user?.uid ?? "")")
                } else {
                    Text("Signed in as \(viewModel.user?.email ?? "EMAIL")")
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    Task {
                        await viewModel.signInWithEmailPassword()
                    }
                } label: {
                    Text("Sign In")
                }
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationViewModel())
}
