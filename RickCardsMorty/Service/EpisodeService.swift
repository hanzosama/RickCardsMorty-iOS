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

// Struct base dependency

public struct EpisodeService {

    static var requestDispatcher: RequestDispatcher {
        RequestDispatcher(environment: .init("prod", host: "https://rickandmortyapi.com/", baseURL: "api/"))
    }

    var fetchEpisodes: (_ id: Int) async throws -> Episode
}

extension DependencyValues {
    public var episodeService: EpisodeService {
        get { self[EpisodeService.self] }
        set { self[EpisodeService.self] = newValue }
    }
}

extension EpisodeService {
    public static let live = Self.init(
        fetchEpisodes: { id in
            let request = EpisodeRequest.id(id: id)
            return try await requestDispatcher.execute(request: request, responseObject: Episode.self)
        }
    )
}

extension EpisodeService: DependencyKey {
    public static var liveValue = EpisodeService.live
    public static var testValue = EpisodeService.mock
}

#if DEBUG
extension EpisodeService {
    public static let mock = Self.init(
        fetchEpisodes: { _ in
            EpisodeMocks.episodeMock()
        }
    )
}
#endif
