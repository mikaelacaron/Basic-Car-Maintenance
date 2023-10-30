//
//  AuthenticationViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 9/14/23.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Foundation
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

@Observable
final class AuthenticationViewModel: ObservableObject {
    var email = ""
    var password = ""
    var confirmPassword = ""
    var authenticationState: AuthenticationState = .unauthenticated
    var user: User?
    var flow: AuthenticationFlow = .signUp
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    
    init() {
            registerAuthStateHandler()
            verifySignInWithAppleAuthenticationState()
        Task {
            user = await signIn()
        }
    }
    
    func signInAnonymously() {
        Task {
            try? await Auth.auth().signInAnonymously()
        }
    }
    
    func signIn() async -> User? {
        var currentUser: User?
        if Auth.auth().currentUser == nil {
            print("No user signed in. Trying to sign in anonymously.")
            do {
                try await Auth.auth().signInAnonymously()
                currentUser = Auth.auth().currentUser
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("User is signed in")
            if let user = Auth.auth().currentUser {
                currentUser = user
            }
        }
        
        if let currentUser {
            AppDefaults.saveUser(id: currentUser.uid)
        }
        return currentUser
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            authenticationState = .unauthenticated
            flow = .signUp
            signInAnonymously()
        } catch {
            print(error)
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            authenticationState = .unauthenticated
            flow = .signUp
            return true
        } catch {
            return false
        }
    }
    
    private func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { _, user in
                self.user = user
                if let id = user?.uid {
                    AppDefaults.saveUser(id: id)
                }
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
            }
        }
    }
}

// MARK: - Sign in with Apple

extension AuthenticationViewModel {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            print(failure.localizedDescription)
        } else if case .success(let authorization) = result {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetdch identify token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce, fullName:
                                                                appleIDCredential.fullName)
                Task {
                    do {
                        _ = try await Auth.auth().signIn(with: credential)
                        if let userId = credential.idToken {
                            AppDefaults.saveUser(id: userId)
                        }
                        authenticationState = .authenticated
                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func verifySignInWithAppleAuthenticationState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                do {
                    
                    let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid) // swiftlint:disable:this line_length
                    switch credentialState {
                    case .authorized:
                        // The Apple ID credential is valid.
                        authenticationState = .authenticated
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        self.signOut()
                    default:
                        break
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce, from Firebase example // swiftlint:disable:this line_length
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

// find a better way to save user's ID
enum AppDefaults {
    static func saveUser(id: String) {
        UserDefaults.standard.setValue(id, forKey: "UserID")
    }
    
    static func getUserID() -> String? {
        UserDefaults.standard.value(forKey: "UserID") as? String
    }
}
