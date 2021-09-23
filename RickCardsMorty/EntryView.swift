//
//  EntryView.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 1/09/21.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        switch authViewModel.sessionState {
        case .signedIn :
            HomeView()
        case .signedOut:
            LoginView()
        }
    }
}

#if DEBUG

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}

#endif
