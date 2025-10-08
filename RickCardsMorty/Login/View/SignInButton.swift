//
//  SignInButton.swift
//  RickCardsMorty
//  This is a class example to customize UIkit view in SwiftUIviews
//  Created by HanzoMac on 30/08/21.
//
import SwiftUI
import GoogleSignIn

struct SignInButton: UIViewRepresentable {
    
    let action: () -> Void
    
    func makeUIView(context: Context) -> GIDSignInButton {
        let googleBtn = GIDSignInButton()
        googleBtn.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)
        // Customize button Here
        return googleBtn
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }

        class Coordinator: NSObject {
            var parent: SignInButton

            init(_ signInButton: SignInButton) {
                self.parent = signInButton
                super.init()
            }

            @objc func doAction(_ sender: Any) {
                self.parent.action()
            }
        }
    
}
