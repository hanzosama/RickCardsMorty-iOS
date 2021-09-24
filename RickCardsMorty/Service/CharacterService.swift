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
    
    case name(name:String,page:Int)
    
    var path: String {
        switch self {
        case .name(_,_):
            fallthrough
        case .all(_):
            return "character"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .all(_):
            fallthrough
        case .name(_,_):
            return .GET
        }
    }
    
    var parameters: RequestParams{
        switch self {
        case .all(let page):
            return .url(["page":page])
        case .name(let name, let page):
            return .url(["page":page,
                         "name":name])
        }
    }
    
    var headers: HTTPHeadersParams?{
        switch self {
        case .all(_):
            fallthrough
        case .name(_,_):
            return [:]
        }
    }
    
    var responseDataType: DataType{
        switch self {
        case .all(_):
            fallthrough
        case .name(_,_):
            return .Json
        }
    }
    
}

protocol CharacterServiceProtocol {
    func fectchCharaters(at index:Int) -> AnyPublisher<CharacterResponse,RequestError>
    func fectchCharaters(like name:String,at index:Int) -> AnyPublisher<CharacterResponse,RequestError>
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
    
    func fectchCharaters(like name: String, at index:Int) -> AnyPublisher<CharacterResponse, RequestError> {
        let request = CharacterRequest.name(name: name,page: index)
        return self.requestDispatcher.execute(request: request, reponseObject: CharacterResponse.self)
    }
    
}
