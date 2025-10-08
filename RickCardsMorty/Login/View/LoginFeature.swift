//
//  LoginFeature.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 7/10/24.
//

import ComposableArchitecture
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

@Reducer
struct LoginFeature {
    
    @Dependency(\.authenticationManager) var authManager
    
    public init() {}
    
    @ObservableState
    struct State: Equatable {
        var sessionStatus: SignInState = .signedOut
        var loading: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case signIn
        case signOut
        case restorePreviusSection
        case signInSuccess
        case signOutSuccess
        case signError
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .signIn:
                state.loading = true
                
                return .run { send in
                    try await authManager.signInUser()
                    await send(.signInSuccess)
                } catch: { _, send in
                    print("There was an error sing in google")
                    await send(.signError)
                }
                
            case .signOut:
                state.loading = true

                return .run { send in
                    do {
                        try await authManager.signOutUser()
                    } catch {
                        print("There was an error closing the app")
                        await send(.signError)
                    }
                    
                    await send(.signOutSuccess)
                }
                
            case .restorePreviusSection:
                state.loading = true
                
                return .run { send in
                    try await authManager.restorePreviousSession()
                    await send(.signInSuccess)
                } catch: { _, send in
                    print("There was an error restoring the session")
                    await send(.signOut)
                }
                
            case .signInSuccess:
                state.loading = false
                state.sessionStatus = .signedIn
                
            case .signOutSuccess:
                state.loading = false
                state.sessionStatus = .signedOut
                
            case .signError:
                state.loading = false
            case .binding:
                
                return .none
            }
            
            return .none
        }
        
    }
}
