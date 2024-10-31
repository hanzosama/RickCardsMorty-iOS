//
//  EpisodeRequest.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 4/10/21.
//

import Foundation
import Combine

import Dependencies

enum EpisodeRequest: Request {
    
    case id(id: Int)
    
    var path: String {
        switch self {
        case .id(let id):
            return "episode/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .id:
            return .GET
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .id:
            return .url([:])
        }
    }
    
    var headers: HTTPHeadersParams? {
        switch self {
        case .id:
            return [:]
        }
    }
    
    var responseDataType: DataType {
        switch self {
        case .id:
            return .json
        }
    }
}

public protocol EpisodeService {
    func fetchEpisodes(id: Int) async throws -> Episode
}

public struct  EpisodeServiceImpl: EpisodeService {
    
    var requestDispatcher: RequestDispatcher {
        RequestDispatcher(environment: .init("prod", host: "https://rickandmortyapi.com/", baseURL: "api/"))
    }
    
    public func fetchEpisodes(id: Int) async throws -> Episode {
        let request = EpisodeRequest.id(id: id)
        return try await self.requestDispatcher.execute(request: request, responseObject: Episode.self)
    }
    
}

extension DependencyValues {
    public var episodeService: EpisodeService {
        get { self[EpisodeServiceKey.self] }
        set { self[EpisodeServiceKey.self] = newValue }
    }
}

extension EpisodeServiceImpl {
    public static let live = EpisodeServiceImpl.init()
}

public enum EpisodeServiceKey: DependencyKey {
    public static var liveValue: any EpisodeService = EpisodeServiceImpl.live
}
