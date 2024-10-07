//
//  AuthenticationViewModel.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 30/08/21.
//
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Combine

class AuthenticationViewModel: ObservableObject {
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var sessionState: SignInState = .signedOut
    @Published var loading: Bool = false
    
    private var configuration: GIDConfiguration?
    
    
    init() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        self.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
    }
    
    func signIn(){
        loading = true
        if GIDSignIn.sharedInstance.currentUser == nil, let configuration = configuration {
            // TODO: Not force rootView
            GIDSignIn.sharedInstance.signIn(withPresenting: (UIApplication.shared.windows.first?.rootViewController)!) { signInResult, error in
                if error == nil, let result = signInResult {
                    self.firebaseAuthentication(user: result.user)
                } else {
                    //TODO: Handle error
                    print("There was an error sing in google")
                }
                self.loading = false
            }
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        firebaseCloseSession()
    }
    
    func restorePreviousSession() {
        loading = true
        print("Restoring the reprevious session..")
        GIDSignIn.sharedInstance.restorePreviousSignIn { googleUser, error in
            if error != nil || googleUser == nil {
                // Show the app's signed-out state.
                self.sessionState = .signedOut
            } else {
                // Show the app's signed-in state.
                self.sessionState = .signedIn
            }
            self.loading = false
        }
    }
    
    private func firebaseAuthentication(user: GIDGoogleUser){
        if let idToken = user.idToken {
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.sessionState = .signedIn
                }
            }
        }
    }
    
    private func firebaseCloseSession(){
        do {
            try Auth.auth().signOut()
            self.sessionState = .signedOut
        }catch{
            print("There was an error closing the app")
        }
    }
    
}
