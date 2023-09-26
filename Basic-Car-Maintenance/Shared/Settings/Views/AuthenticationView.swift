//
//  AuthenticationView.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/17/23.
//

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        switch viewModel.flow {
        case .signIn:
            SignInView()
                .environmentObject(viewModel)
        case .signUp:
            SignUpView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
            .environmentObject(AuthenticationViewModel())
    }
}
