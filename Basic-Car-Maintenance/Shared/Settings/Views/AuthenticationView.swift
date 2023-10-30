//
//  AuthenticationView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/17/23.
//

import AuthenticationServices
import FirebaseAnalyticsSwift
import SwiftUI

struct AuthenticationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = AuthenticationViewModel()
    
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
        .analyticsScreen(name: "\(Self.self)")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
    }
}
