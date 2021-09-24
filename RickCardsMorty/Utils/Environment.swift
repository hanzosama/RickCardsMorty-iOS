//
//  Environment.swift
//  RickCardsMorty
//  This is to share the cache trought the Enviroment of SwifUI views
//  Created by HanzoMac on 24/09/21.
//

import SwiftUI

//MARK: - Environment Keys

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

struct FontTypeKey:EnvironmentKey {
    static let defaultValue: String = "ChalkboardSE-Regular"
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
    var mainFont: String {
        get { self[FontTypeKey.self] }
        set { self[FontTypeKey.self] = newValue }
    }
}

//MARK: - Environment Structures

public struct NetworkingEnvironment {
    public var name:String
    public var host:String
    public var baseURL:String
    public var headers:[String:Any] = [:]
    public var cachePolicy: URLRequest.CachePolicy  = .reloadIgnoringLocalAndRemoteCacheData
    
    public init(_ name: String, host: String, baseURL:String) {
        self.name = name
        self.host = host
        self.baseURL = baseURL
    }
}
