//
//  AuthenticationView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import AuthenticationServices
import SwiftUI

struct AuthenticationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var viewModel: AuthenticationViewModel
    
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            if let user = viewModel.user, user.isAnonymous {
                Text("Logged in anonymously with ID: \(user.uid)")
                
                Section {
                    switch viewModel.flow {
                    case .signIn:
                        SignInWithAppleButton(.signIn) { request in
                            viewModel.handleSignInWithAppleRequest(request)
                        } onCompletion: { result in
                            viewModel.handleSignInWithAppleCompletion(result)
                        }
                        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                        .frame(minHeight: 44)
                    case .signUp:
                        SignInWithAppleButton(.signUp) { request in
                            viewModel.handleSignInWithAppleRequest(request)
                        } onCompletion: { result in
                            viewModel.handleSignInWithAppleCompletion(result)
                        }
                        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                        .frame(minHeight: 44)
                    }
                }
                .listRowBackground(Color.clear)
            } else {
                VStack(alignment: .center, spacing: 8) {
                    Text("Signed in as \(viewModel.user?.email ?? "No Email Found")")
                    
                    Button {
                        viewModel.signOut()
                    } label: {
                        Text("Sign Out")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .analyticsView("\(Self.self)")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(viewModel: AuthenticationViewModel())
    }
}
