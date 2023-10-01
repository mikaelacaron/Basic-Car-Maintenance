//
//  SignInView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/25/23.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Form {
            Section {
                if viewModel.user?.isAnonymous != nil {
                    Text("Logged in anonymously with ID: \(viewModel.user?.uid ?? "")")
                } else {
                    Text("Signed in as \(viewModel.user?.email ?? "No Email Found")")
                }
            }
            
            Section {
                SignInWithAppleButton(.signIn) { request in
                    viewModel.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    viewModel.handleSignInWithAppleCompletion(result)
                }
                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                .frame(minHeight: 44)
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationViewModel())
}
