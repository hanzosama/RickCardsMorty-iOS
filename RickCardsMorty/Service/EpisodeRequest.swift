//
//  EpisodeRequest.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 4/10/21.
//

import Foundation
import Combine

enum EpisodeRequest: Request{
    
    case id(id:Int)
    
    var path: String {
        switch self {
        case .id(let id):
            return "episode/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .id(_):
            return .GET
        }
    }
    
    var parameters: RequestParams{
        switch self {
        case .id(_):
            return .url([:])
        }
    }
    
    var headers: HTTPHeadersParams? {
        switch self {
        case .id(_):
            return [:]
        }
    }
    
    var responseDataType: DataType{
        switch self {
        case .id(_):
            return .json
        }
    }
    
    
}


protocol EpisodeServiceProtocol {
    func fetchEpisodes(id:Int)  -> AnyPublisher<Episode,RequestError>
}

class EpisodeService: EpisodeServiceProtocol {
    
    private var cancelable: Set<AnyCancellable> = []
    
    var requestDispatcher:RequestDispatcher {
        RequestDispatcher(environment: .init("prod", host: "https://rickandmortyapi.com/", baseURL: "api/"))
    }
    
    func fetchEpisodes(id: Int) -> AnyPublisher<Episode, RequestError> {
        let request = EpisodeRequest.id(id: id)
        return self.requestDispatcher.execute(request: request, reponseObject: Episode.self)
    }
    
    
}
