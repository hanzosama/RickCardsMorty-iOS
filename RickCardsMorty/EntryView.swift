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
        if authenticationManager.isLoggedIn() {
            HomeView()
                .transition(.slide)
        } else {
            LoginView(store: self.store.scope(state: \.login, action: \.login))
                .transition(.slide)
        }
    }
}
