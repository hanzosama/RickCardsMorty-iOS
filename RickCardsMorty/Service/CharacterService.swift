//
//  CharacterService.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 13/09/21.
//

import Foundation
import Combine

enum CharacterRequest: Request{
    case all(page:Int)
    
    var path: String {
        switch self {
        case .all(_):
            return "character"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .all(_):
            return .GET
        }
    }
    
    var parameters: RequestParams{
        switch self {
        case .all(let page):
            return .url(["page":page])
        }
    }
    
    var headers: HTTPHeadersParams?{
        switch self {
        case .all(_):
            return [:]
        }
    }
    
    var responseDataType: DataType{
        switch self {
        case .all(_):
            return .Json
        }
    }
    
}

protocol CharacterServiceProtocol {
    func fectchCharaters(at index:Int) -> AnyPublisher<CharacterResponse,RequestError>
}

class CharacterService : CharacterServiceProtocol  {
    
    private var cancelable: Set<AnyCancellable> = []
    
    var requestDispatcher:RequestDispatcher {
        RequestDispatcher(environment: .init("prod", host: "https://rickandmortyapi.com/", baseURL: "api/"))
    }
    
    func fectchCharaters(at index:Int) -> AnyPublisher<CharacterResponse,RequestError>{
        let request = CharacterRequest.all(page: index)
        return self.requestDispatcher.execute(request: request, reponseObject: CharacterResponse.self)
    }
    
}
