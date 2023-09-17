//
//  AuthenticationViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/14/23.
//

import Foundation
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case signIn
    case signUp
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    @Published var user: User?
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
    }
    
    func signInWithEmailPassword() async -> Bool {
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            user = authResult.user
            return true
        } catch {
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        return false
    }
    
    func signOut() {
        
    }
    
    func deleteAccount() async -> Bool {
        return false
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { _, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
            }
        }
    }
}
