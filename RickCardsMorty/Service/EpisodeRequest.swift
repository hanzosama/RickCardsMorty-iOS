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

public struct  EpisodeService {
    
    var requestDispatcher: RequestDispatcher {
        RequestDispatcher(environment: .init("prod", host: "https://rickandmortyapi.com/", baseURL: "api/"))
    }
    
    func fetchEpisodes(id: Int) async throws -> Episode {
        let request = EpisodeRequest.id(id: id)
        return try await self.requestDispatcher.execute(request: request, reponseObject: Episode.self)
    }
    
}

extension DependencyValues {
    public var episodeService: EpisodeService {
        get { self[EpisodeService.self] }
        set { self[EpisodeService.self] = newValue }
    }
}

extension EpisodeService {
    public static let live = EpisodeService.init()
}

extension EpisodeService: DependencyKey {
    public static var liveValue = EpisodeService.live
}
