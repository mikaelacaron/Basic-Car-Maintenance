//
//  AuthenticationViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/14/23.
//

import Foundation
import FirebaseAuth
import SwiftUI

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
    @Published var confirmPassword = ""
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    @Published var user: User?
    
    @Published var flow: AuthenticationFlow = .signUp
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
        signIn()
    }
    
    func linkWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            if let user {
                let result = try await user.link(with: credential)
                self.user = result.user
                authenticationState = .authenticated
                return true
            } else {
                fatalError("No user was signed in. This should not happen.")
            }
        } catch {
            print(error)
            authenticationState = .unauthenticated
            return false
        }
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
    
    func signInAnonymously() {
        Task {
            try? await Auth.auth().signInAnonymously()
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            authenticationState = .authenticated
            return true
        } catch {
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signIn() {
        if Auth.auth().currentUser == nil {
            print("Nobody is signed in. Trying to sign in anonymously.")
            Task {
                do {
                    try await Auth.auth().signInAnonymously()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("Someone is signed in")
            if let user = Auth.auth().currentUser {
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            authenticationState = .unauthenticated
            signInAnonymously()
        } catch {
            print(error)
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            authenticationState = .unauthenticated
            return true
        } catch {
            return false
        }
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
