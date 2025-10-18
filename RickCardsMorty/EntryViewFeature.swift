//
//  EntryViewFeature.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 9/10/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct EntryViewFeature {
    
    @Dependency(\.authenticationManager) var authenticationManager
    
    public init() { }
    
    @ObservableState
    enum State: Equatable {
        case login(LoginFeature.State)
        case home(HomeFeature.State)
    }
    
    enum Action {
        case login(LoginFeature.Action)
        case home(HomeFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.login, action: \.login) {
            LoginFeature()
        }
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        // Parent reducer handles state transitions FIRST
        Reduce { state, action in
            switch action {
            case .login(.signInSuccess):
                state = .home(HomeFeature.State.init())
            case .login(.signOut), .login(.signError):
                state = .login(LoginFeature.State.init())
            case .login:
                break
            case .home(.logoutTap):
                state = .login(LoginFeature.State.init())
                return .run { _ in
                    try? await authenticationManager.signOutUser()
                }
            case .home:
                break
            }
            return .none
        }
    }
    
}
