//
//  LoginViewTests.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 22/10/25.
//

import Testing

import SnapshotTesting
import ComposableArchitecture
@testable import RickCardsMorty

@MainActor
@Suite(.snapshots(record: .failed))
class LoginViewTests: BaseSnapshotTestCase {
    @Test("LoginView snapshot test default")
    func loginViewSnapshotDefaultTest() {
        
        let store = Store(initialState: LoginFeature.State(loading: false)) {
            LoginFeature()
        }
        
        let loginView = LoginView(store: store)
        
        assertSnapshot(
            of: loginView,
            as: .image(precision: 0.7,
            layout: .device(config: .iPhoneSe)),
            record: false
        )
        
    }
    
    
    @Test("LoginView snapshot test not login")
    func loginViewSnapshotNoLoginTest() {
        
        let store = Store(initialState: LoginFeature.State(sessionStatus: .signedOut ,loading: false)) {
            LoginFeature()
        }
        
        let loginView = LoginView(store: store)
        
        assertSnapshot(
            of: loginView,
            as: .image(precision: 0.7,
            layout: .device(config: .iPhoneSe)),
            record: false
        )
        
    }
    
    @Test("LoginView snapshot tes login signedIn")
    func loginViewSnapshotLoginSignedInTest() {
        
        let store = Store(initialState: LoginFeature.State(sessionStatus: .signedIn ,loading: false)) {
            LoginFeature()
        }
        
        let loginView = LoginView(store: store)
        
        assertSnapshot(
            of: loginView,
            as: .image(precision: 0.7,
            layout: .device(config: .iPhoneSe)),
            record: false
        )
        
    }
}
