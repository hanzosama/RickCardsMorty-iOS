//
//  ContentView.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 30/08/21.
//

import SwiftUI

import ComposableArchitecture
import GoogleSignIn

struct LoginView: View {
    @Perception.Bindable var store: StoreOf<LoginFeature>
    
    @Environment(\.mainFont) var mainFont
    
    var body: some View {
        WithPerceptionTracking {
            ZStack { // Is better to use ZStack for Background colors∫
                
                Color("generalBgColor").ignoresSafeArea()
                
                VStack {
                    
                    Image("rickIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120, alignment: .top)
                        .padding()
                        .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 0)
                    
                    ActivityIndicator(show: $store.loading)
                        .padding(.horizontal, 150)
                    
                    Text("Please sign on with:")
                        .font(Font.custom(mainFont, size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 30)
                    
                    SignInButton() { // This is the target closure in the custom view
                        store.send(.signIn)
                    }
                    .padding(.horizontal, 60)
                    
                }
            }
            .onAppear {
                store.send(.restorePreviusSection)
            }
        }
        
    }
}

#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State(),
            reducer: LoginFeature.init
        )
    )
}
