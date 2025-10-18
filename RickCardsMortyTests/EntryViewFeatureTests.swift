//
//  EntryViewFeatureTests.swift
//  RickCardsMortyTests
//
//  Created by Jhoan Mauricio Vivas Rubiano on 11/10/24.
//

import Testing
import ComposableArchitecture

@testable import RickCardsMorty

@MainActor
@Suite("EntryViewFeature Tests")
struct EntryViewFeatureTests {
    
    // MARK: - Test Data
    
    private var loginState: EntryViewFeature.State {
        .login(LoginFeature.State())
    }
    
    private var homeState: EntryViewFeature.State {
        .home(HomeFeature.State())
    }
    
    // MARK: - Initial State Tests
    
    @Test("Initial state should be configurable")
    func initialState() async throws {
        let store = TestStore(initialState: loginState) {
            EntryViewFeature()
        }
        
        // Verify initial state is login
        switch store.state {
        case .login:
            // Expected case
            break
        case .home:
            Issue.record("Expected login state, got home state")
        }
    }
    
    // MARK: - Login Flow Tests
    
    @Test("Sign in success should transition to home state")
    func signInSuccessTransition() async throws {
        let store = TestStore(initialState: loginState) {
            EntryViewFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
        }

        await store.send(.login(.signInSuccess)) {
            $0 = .home(HomeFeature.State())
        }
    }
    
    // Note: Tests for .signOut and .signError from .home state were removed
    // because they test invalid cross-boundary scenarios that TCA's ifCaseLet
    // explicitly prohibits. In the actual app, logout from home uses
    // .home(.logoutTap), which is tested in "Home logout should transition to login"

    @Test("Other login actions should not change entry state")
    func otherLoginActionsNoStateChange() async throws {
        let store = TestStore(initialState: loginState) {
            EntryViewFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
        }

        // Test signIn - it triggers LoginFeature reducer which sends signInSuccess
        await store.send(.login(.signIn)) {
            if case .login(var loginState) = $0 {
                loginState.loading = true
                $0 = .login(loginState)
            }
        }

        // Receive the signInSuccess from LoginFeature reducer
        await store.receive(\.login.signInSuccess) {
            $0 = .home(HomeFeature.State())
        }

        // Create new store for other actions that don't change entry state
        let store2 = TestStore(initialState: loginState) {
            EntryViewFeature()
        }

        // signOutSuccess doesn't change state (already loading=false, sessionStatus=.signedOut)
        await store2.send(.login(.signOutSuccess))

        // binding action doesn't change entry state
        await store2.send(.login(.binding(.set(\.loading, true)))) {
            if case .login(var loginState) = $0 {
                loginState.loading = true
                $0 = .login(loginState)
            }
        }
    }
    
    // MARK: - Home Flow Tests
    
    @Test("Home logout should transition to login and call sign out")
    func homeLogoutTransition() async throws {
        var signOutCalled = false

        let store = TestStore(initialState: homeState) {
            EntryViewFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
            $0.authenticationManager.signOutUser = {
                signOutCalled = true
            }
        }

        // Disable exhaustivity since the async signOut effect runs after state transition
        store.exhaustivity = .off

        await store.send(.home(.logoutTap)) {
            $0 = .login(LoginFeature.State())
        }

        // Verify that signOutUser was called
        #expect(signOutCalled)
    }
    
    @Test("Home logout handles sign out errors gracefully")
    func homeLogoutErrorHandling() async throws {
        var signOutCalled = false

        let store = TestStore(initialState: homeState) {
            EntryViewFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
            $0.authenticationManager.signOutUser = {
                signOutCalled = true
                throw MockError.signOutFailed
            }
        }

        // Disable exhaustivity since the async signOut effect runs after state transition
        store.exhaustivity = .off

        await store.send(.home(.logoutTap)) {
            $0 = .login(LoginFeature.State())
        }

        // Should still transition to login even if sign out fails
        #expect(signOutCalled)
    }
    
    @Test("Other home actions should not change entry state")
    func otherHomeActionsNoStateChange() async throws {
        // Start with home state that has some data
        var initialHome = HomeFeature.State()
        initialHome.queryString = "Rick"
        initialHome.currentPage = 2

        let store = TestStore(initialState: .home(initialHome)) {
            EntryViewFeature()
        } withDependencies: {
            // Provide mainQueue for debounce operations
            $0.mainQueue = .immediate
        }

        // Disable exhaustivity - CharacterService mock will trigger processResponse
        store.exhaustivity = .off

        // Test various home actions without changing entry state
        await store.send(.home(.resetData))
        await store.send(.home(.emptySearch))
        await store.send(.home(.binding(.set(\.queryString, "test"))))

        // Verify still in home state
        if case .home = store.state {
            // Success - still in home state
        } else {
            Issue.record("Expected to remain in home state")
        }
    }
    
    // MARK: - State Scope Tests
    
    @Test("Login state scope works correctly")
    func loginStateScope() async throws {
        var initialLoginState = LoginFeature.State()
        initialLoginState.loading = true
        
        let store = TestStore(initialState: .login(initialLoginState)) {
            EntryViewFeature()
        }
        
        await store.send(.login(.binding(.set(\.loading, false)))) {
            if case .login(var loginState) = $0 {
                loginState.loading = false
                $0 = .login(loginState)
            }
        }
    }
    
    @Test("Home state scope works correctly")
    func homeStateScope() async throws {
        var initialHomeState = HomeFeature.State()
        initialHomeState.queryString = ""

        let store = TestStore(initialState: .home(initialHomeState)) {
            EntryViewFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
        }

        // Disable exhaustivity - CharacterService mock will trigger processResponse
        store.exhaustivity = .off

        // Test that binding to queryString works within home scope
        await store.send(.home(.binding(.set(\.queryString, "Rick"))))

        // Verify state updated and still in home
        if case .home(let homeState) = store.state {
            #expect(homeState.queryString == "Rick")
        } else {
            Issue.record("Expected to remain in home state")
        }
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete login flow integration")
    func completeLoginFlowIntegration() async throws {
        var signOutCalled = false

        let store = TestStore(initialState: loginState) {
            EntryViewFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
            $0.authenticationManager.signOutUser = {
                signOutCalled = true
            }
        }

        // Disable exhaustivity for state transitions
        store.exhaustivity = .off

        // Start with login, sign in successfully
        await store.send(.login(.signInSuccess)) {
            $0 = .home(HomeFeature.State())
        }

        // Then logout from home
        await store.send(.home(.logoutTap)) {
            $0 = .login(LoginFeature.State())
        }

        #expect(signOutCalled)
    }
    
    @Test("State transitions maintain proper structure")
    func stateTransitionStructure() async throws {
        let store = TestStore(initialState: loginState) {
            EntryViewFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
        }

        // Disable exhaustivity for state transition
        store.exhaustivity = .off

        // Transition to home
        await store.send(.login(.signInSuccess)) {
            $0 = .home(HomeFeature.State())
        }

        // Verify home state has expected initial values
        if case .home(let homeState) = store.state {
            #expect(homeState.characters.isEmpty)
            #expect(homeState.isLoadingPage == false)
            #expect(homeState.queryString.isEmpty)
            #expect(homeState.currentPage == 1)
            #expect(homeState.canLoadMorePages == true)
        } else {
            Issue.record("Expected home state after sign in success")
        }
    }
}

// MARK: - Mock Errors

enum MockError: Error {
    case signOutFailed
}
