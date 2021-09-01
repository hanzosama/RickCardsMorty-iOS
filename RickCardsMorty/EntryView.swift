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
            Text("Home")
        case .signedOut:
            LoginView()
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
