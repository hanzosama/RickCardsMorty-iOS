//
//  EntryView.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 1/09/21.
//

import SwiftUI

import ComposableArchitecture

struct EntryView: View {
    @Environment(\.mainFont) var mainFont
    @Dependency(\.authenticationManager) var authenticationManager
    
    let store: StoreOf<EntryViewFeature>
    
    var body: some View {
        switch store.state {
        case .home:
            if let store = store.scope(state: \.home, action: \.home) {
                HomeView(store: store)
                    .transition(.slide)
            }
        case .login:
            if let store = store.scope(state: \.login, action: \.login) {
                LoginView(store: store)
                    .transition(.slide)
            }
        }
    }
}

#Preview {
    EntryView(
        store:
            Store(
                initialState: EntryViewFeature.State.login(.init()),
                reducer: EntryViewFeature.init
            )
    )
}
