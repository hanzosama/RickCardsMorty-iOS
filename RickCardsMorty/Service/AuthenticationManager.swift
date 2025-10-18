//
//  AuthenticationManager.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 9/10/24.
//

import Foundation

import Dependencies
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

public enum SignInState {
    case signedIn
    case signedOut
}

public struct AuthenticationManager {

    var signInUser: @MainActor () async throws -> Void

    var signOutUser: @MainActor () async throws -> Void

    var restorePreviousSession: () async throws -> Void

    var isLoggedIn: () -> Bool
}

extension DependencyValues {
    public var authenticationManager: AuthenticationManager {
        get { self[AuthenticationManager.self] }
        set { self[AuthenticationManager.self] = newValue }
    }
}

extension AuthenticationManager {
    public static let live = Self(
        signInUser: {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration

            guard GIDSignIn.sharedInstance.currentUser == nil else {
                return
            }

            // Google Authentication
            let signInResult = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: (UIApplication.getKeyWindow()?.rootViewController)!
            )

            guard let idToken = signInResult.user.idToken else { return }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: signInResult.user.accessToken.tokenString
            )

            // Firebase Authentication
            _ = try await Auth.auth().signIn(with: credential)
        },
        signOutUser: {
            // Google signOut
            GIDSignIn.sharedInstance.signOut()

            // Firebase signOut
            do {
                try Auth.auth().signOut()
            } catch {
                print("There was an error closing the app")
                throw error
            }
        },
        restorePreviousSession: {
            print("Restoring the previous session..")
            try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            print("Session ok")
        },
        isLoggedIn: {
            GIDSignIn.sharedInstance.currentUser != nil
        }
    )
}

extension AuthenticationManager: DependencyKey {
    public static let liveValue = AuthenticationManager.live
    public static let testValue = AuthenticationManager.mock
}

#if DEBUG
extension AuthenticationManager {
    public static let mock = Self(
        signInUser: {
            // Mock implementation - does nothing, succeeds immediately
            print("[Mock] User signed in successfully")
        },
        signOutUser: {
            // Mock implementation - does nothing, succeeds immediately
            print("[Mock] User signed out successfully")
        },
        restorePreviousSession: {
            // Mock implementation - does nothing, succeeds immediately
            print("[Mock] Previous session restored")
        },
        isLoggedIn: {
            // Mock implementation - returns false by default
            false
        }
    )
}
#endif
