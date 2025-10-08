//
//  CharacterService.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 13/09/21.
//

import Foundation
import Combine

import Dependencies

enum CharacterRequest: Request {
    case all(page: Int)
    
    case name(name: String, page: Int)
    
    case multiple(ids: [String])
    
    var path: String {
        switch self {
        case .multiple(let ids):
            return "character/\(ids.joined(separator: ","))"
        case .name:
            return "character"
        case .all:
            return "character"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .multiple:
            return .GET
        case .all:
            return .GET
        case .name:
            return .GET
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .multiple:
            return .url([:])
        case .all(let page):
            return .url(["page": page])
        case .name(let name, let page):
            return .url(["page": page,
                         "name": name])
        }
    }
    
    var headers: HTTPHeadersParams? {
        switch self {
        case .multiple:
            return [:]
        case .all:
            return [:]
        case .name:
            return [:]
        }
    }
    
    var responseDataType: DataType {
        switch self {
        case .multiple:
            return .json
        case .all:
            return .json
        case .name:
            return .json
        }
    }
    
}

// Struct base dependecy

public struct CharacterService {
    
    static var requestDispatcher: RequestDispatcher {
        RequestDispatcher(environment: .init("prod", host: "https://rickandmortyapi.com/", baseURL: "api/"))
    }
    
    var fetchCharacters: (_ index: Int) async throws -> CharacterResponse
    
    var fetchCharactersLike: (_ name: String, _ index: Int) async throws -> CharacterResponse
    
    var fectchCharatersBy: (_ ids: [String]) async throws -> [Character]
    
}

extension DependencyValues {
    public var characterService: CharacterService {
        get { self[CharacterService.self] }
        set { self[CharacterService.self] = newValue }
    }
}

extension CharacterService {
    public static let live = Self.init(
        fetchCharacters: { index in
            let request = CharacterRequest.all(page: index)
            return try await requestDispatcher.execute(request: request, responseObject: CharacterResponse.self)
        },
        fetchCharactersLike: { name, index in
            let request = CharacterRequest.name(name: name, page: index)
            return try await requestDispatcher.execute(request: request, responseObject: CharacterResponse.self)
        },
        fectchCharatersBy: { ids in
            let request = CharacterRequest.multiple(ids: ids)
            return try await requestDispatcher.execute(request: request, responseObject: [Character].self)
        }
    )
}

extension CharacterService: DependencyKey {
    public static var liveValue = CharacterService.live
    public static var testValue = CharacterService.mock
}

#if DEBUG
extension CharacterService {
    public static let mock = Self.init(
        fetchCharacters: { _ in
            CharactersMocks.characterResponseMock()
        },
        fetchCharactersLike: { _, _ in
            CharactersMocks.characterResponseMock()
        },
        fectchCharatersBy: { _ in
            [CharactersMocks.characterMock()]
        }
    )
}
#endif
