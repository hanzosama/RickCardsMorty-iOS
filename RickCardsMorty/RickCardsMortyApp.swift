//
//  RickCardsMortyApp.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 30/08/21.
//

import SwiftUI

import ComposableArchitecture
import XCTestDynamicOverlay
import GoogleSignIn
import Firebase

@main
struct RickCardsMortyApp: App {
    
    @Environment(\.scenePhase) private var scenePhase // To handle phases instead of entirey app lifecycle
    
    init() {
        // This constructur is better to setup initial states that does not depend of App life cycle
        setupAuthentication()
    }
    // Main entry point in swiftUI life cycle, notice how the protocol return a Scene, not a View
    var body: some Scene {
        WindowGroup { // This is a cross-platform struct that represents a scene of multiple window
            if !_XCTIsTesting {
                WithPerceptionTracking {
                    EntryView(
                        store: Store(initialState: EntryViewFeature.State.login(.init())) {
                            EntryViewFeature()
                        }
                    )
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                }
            }
            
        }
        .onChange(of: scenePhase) { _ in // This is just for knowledge purposes
        }
    }
}

extension RickCardsMortyApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
