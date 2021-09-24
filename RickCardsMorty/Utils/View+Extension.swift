//
//  View+Extension.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 23/09/21.
//

import SwiftUI
//Custom extensions for SwiftUI view
extension View{
    //Gettting the safe Area of UIkit
    func getSafeArea() -> UIEdgeInsets{
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor,titleFontName:String? = nil ,largeTitleFontName:String? = nil) -> some View {
        self.modifier(NavigationBarCustom(backgroundColor: backgroundColor, tintColor: tintColor,titleFontName: titleFontName,largeTitleFontName: largeTitleFontName))
    }
}
