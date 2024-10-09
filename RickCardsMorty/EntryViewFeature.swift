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
    
    public init() { }
    
    struct State: Equatable {
        var login: LoginFeature.State = .init()
    }
    
    enum Action {
        case login(LoginFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        EmptyReducer()
        
        Scope(state: \.login, action: \.login) {
            LoginFeature()
        }
    }
    
}
