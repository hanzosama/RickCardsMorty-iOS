//
//  App+Extension.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 8/10/25.
//

import Foundation
import UIKit

extension UIApplication {
    static func getKeyWindow() -> UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}
