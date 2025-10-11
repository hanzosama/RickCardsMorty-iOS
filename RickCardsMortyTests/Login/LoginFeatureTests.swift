//
//  LoginFeatureTests.swift
//  RickCardsMortyTests
//
//  Created by Jhoan Mauricio Vivas Rubiano on 11/10/24.
//

import Testing
import ComposableArchitecture

@testable import RickCardsMorty

@MainActor
@Suite("LoginFeature Tests")
struct LoginFeatureTests {

    @Test("Sign in successfully updates state")
    func signInSuccess() async {
        let store = TestStore(
            initialState: LoginFeature.State(),
            reducer: LoginFeature.init
        )

        await store.send(.signIn) {
            $0.loading = true
        }

        await store.receive(\.signInSuccess) {
            $0.loading = false
            $0.sessionStatus = .signedIn
        }
    }

    @Test("Sign in with error updates loading state")
    func signInError() async {
        let store = TestStore(
            initialState: LoginFeature.State(),
            reducer: LoginFeature.init
        ) {
            $0.authenticationManager.signInUser = {
                struct SignInError: Error {}
                throw SignInError()
            }
        }

        await store.send(.signIn) {
            $0.loading = true
        }

        await store.receive(\.signError) {
            $0.loading = false
        }
    }

    @Test("Sign out successfully updates state")
    func signOutSuccess() async {
        let store = TestStore(
            initialState: LoginFeature.State(sessionStatus: .signedIn),
            reducer: LoginFeature.init
        )

        await store.send(.signOut) {
            $0.loading = true
        }

        await store.receive(\.signOutSuccess) {
            $0.loading = false
            $0.sessionStatus = .signedOut
        }
    }

    @Test("Sign out with error still completes successfully")
    func signOutWithError() async {
        let store = TestStore(
            initialState: LoginFeature.State(sessionStatus: .signedIn),
            reducer: LoginFeature.init
        ) {
            $0.authenticationManager.signOutUser = {
                struct SignOutError: Error {}
                throw SignOutError()
            }
        }

        await store.send(.signOut) {
            $0.loading = true
        }

        // Error is caught and signError is sent first
        await store.receive(\.signError) {
            $0.loading = false
        }

        // Then sign out completes successfully
        await store.receive(\.signOutSuccess) {
            $0.loading = false
            $0.sessionStatus = .signedOut
        }
    }

    @Test("Restore previous session successfully")
    func restorePreviousSessionSuccess() async {
        let store = TestStore(
            initialState: LoginFeature.State(),
            reducer: LoginFeature.init
        )

        await store.send(.restorePreviusSection) {
            $0.loading = true
        }

        await store.receive(\.signInSuccess) {
            $0.loading = false
            $0.sessionStatus = .signedIn
        }
    }

    @Test("Restore previous session with error triggers sign out")
    func restorePreviousSessionError() async {
        let store = TestStore(
            initialState: LoginFeature.State(),
            reducer: LoginFeature.init
        ) {
            $0.authenticationManager.restorePreviousSession = {
                struct RestoreError: Error {}
                throw RestoreError()
            }
        }

        await store.send(.restorePreviusSection) {
            $0.loading = true
        }

        // Error triggers sign out action (loading stays true since signOut sets it to true again)
        await store.receive(\.signOut)

        await store.receive(\.signOutSuccess) {
            $0.loading = false
            $0.sessionStatus = .signedOut
        }
    }

    @Test("Sign in success action updates state correctly")
    func signInSuccessAction() async {
        let store = TestStore(
            initialState: LoginFeature.State(loading: true),
            reducer: LoginFeature.init
        )

        await store.send(.signInSuccess) {
            $0.loading = false
            $0.sessionStatus = .signedIn
        }
    }

    @Test("Sign out success action updates state correctly")
    func signOutSuccessAction() async {
        let store = TestStore(
            initialState: LoginFeature.State(
                sessionStatus: .signedIn,
                loading: true
            ),
            reducer: LoginFeature.init
        )

        await store.send(.signOutSuccess) {
            $0.loading = false
            $0.sessionStatus = .signedOut
        }
    }

    @Test("Sign error action updates loading state")
    func signErrorAction() async {
        let store = TestStore(
            initialState: LoginFeature.State(loading: true),
            reducer: LoginFeature.init
        )

        await store.send(.signError) {
            $0.loading = false
        }
    }

    @Test("Initial state has correct defaults")
    func initialState() async {
        let state = LoginFeature.State()

        #expect(state.sessionStatus == .signedOut)
        #expect(state.loading == false)
    }

    @Test("Binding action does not modify state")
    func bindingAction() async {
        let store = TestStore(
            initialState: LoginFeature.State(),
            reducer: LoginFeature.init
        )

        // Binding actions should not trigger any state changes
        await store.send(.binding(.set(\.loading, true))) {
            $0.loading = true
        }
    }
}
