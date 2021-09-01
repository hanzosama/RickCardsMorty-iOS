//
//  AuthenticationViewModel.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 30/08/21.
//

import Firebase
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
    }
    
    func signIn(){
        loading = true
        if GIDSignIn.sharedInstance.currentUser == nil, let configuration = configuration {
            // TODO: Not force rootView
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: (UIApplication.shared.windows.first?.rootViewController)!) { googleUser, error in
                if error == nil , let user = googleUser {
                    self.firebaseAuthentication(user: user)
                }else{
                    // Handle error
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
        if let idToken = user.authentication.idToken {
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.authentication.accessToken)
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
