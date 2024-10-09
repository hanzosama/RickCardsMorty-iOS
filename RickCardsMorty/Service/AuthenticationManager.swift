//
//  AuthenticationManager.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 9/10/24.
//

import Foundation

import ComposableArchitecture
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

public enum SignInState {
    case signedIn
    case signedOut
}

public struct AuthenticationManager {
    private var configuration: GIDConfiguration?
    
    public init() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        self.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
    }
    
    public func signInUser() async throws {
        guard configuration != nil, GIDSignIn.sharedInstance.currentUser == nil else {
            return
        }
        
        // Google Authentication
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: (UIApplication.shared.windows.first?.rootViewController)!)
        
        guard let idToken = signInResult.user.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: signInResult.user.accessToken.tokenString)
        
        // Firebase Authentication
         _ = try await Auth.auth().signIn(with: credential)
        
    }
    
    public func signOutUser() throws {
        guard configuration != nil else {
            return
        }
        
        // Google signOut
        GIDSignIn.sharedInstance.signOut()
        
        // Firebase signOut
        do {
            try Auth.auth().signOut()
        } catch {
            print("There was an error closing the app")
        }
    }
    
    public func restorePreviousSession() async throws {
        print("Restoring the reprevious session..")
        try await GIDSignIn.sharedInstance.restorePreviousSignIn()
    }
    
    public func isLoggedIn() -> Bool {
        GIDSignIn.sharedInstance.currentUser != nil
    }
}

extension DependencyValues {
    public var authenticationManager: AuthenticationManager {
        get { self[AuthenticationManager.self] }
        set { self[AuthenticationManager.self] = newValue }
    }
}

extension AuthenticationManager {
    public static let live =  AuthenticationManager.init()
}

extension AuthenticationManager: DependencyKey {
    public static let liveValue = AuthenticationManager.live
    // TODO: Create Mock cases
    // public static let testValue: AuthenticationManager.mock
}
