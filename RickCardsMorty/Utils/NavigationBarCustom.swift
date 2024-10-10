//
//  NavigationConfigurator.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 23/09/21.
//

import Foundation
import SwiftUI
import UIKit

struct NavigationBarCustom: ViewModifier {
    
    init(
        backgroundColor: UIColor,
        tintColor: UIColor,
        titleFontName: String? = nil,
        largeTitleFontName: String? = nil
    ) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        
        if let largeTitleFontName = largeTitleFontName, let largeTitleFont = UIFont(name: largeTitleFontName, size: 40) {
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor, .font: largeTitleFont]
        } else {
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
        }
        
        if let titleFontName = titleFontName, let titleFont = UIFont(name: titleFontName, size: 20) {
            coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor, .font: titleFont]
            
        } else {
            coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
            
        }
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = tintColor
        
    }
    
    func body(content: Content) -> some View {
        content
    }
}
