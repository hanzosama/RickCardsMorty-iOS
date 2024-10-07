//
//  RickCardsMortyApp.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 30/08/21.
//

import SwiftUI
import GoogleSignIn
import Firebase

@main
struct RickCardsMortyApp: App {
    
    @Environment(\.scenePhase) private var scenePhase //To handle phases instead of entirey app lifecycle
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate //To handle the App faces according to legacy App Delegate protocol
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    init() {
        // this constructur is better to setup initial states that does not depend of App life cycle
        setupAuthentication()
    }
    //Main entry point in swiftUI life cycle, notice how the protocol return a Scene, not a View
    var body: some Scene {
        WindowGroup { //This is a cross-platform struct that represents a scene of multiple window
            EntryView()
                .environmentObject(viewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
        .onChange(of: scenePhase) { phase in //This is just for knowledge purposes
            switch phase {
            case .background:
                break
            case .inactive:
                break
            case .active:
                break
            default:
                break
            }
        }
    }
}

extension RickCardsMortyApp {
    private func setupAuthentication(){
        FirebaseApp.configure()
    }
}
