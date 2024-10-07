//
//  Request.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 13/09/21.
//

public typealias HTTPHeadersParams = [String: Any]

public enum DataType {
    case json
    case data
}


public enum HTTPMethod: String {
    case POST
    case PUT
    case GET
    case DELETE
    case PATCH
    case HEAD
}

public enum RequestParams {
    case body(_: [String: Any])
    case url(_: [String: Any])
}

public protocol Request{
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: HTTPHeadersParams? { get }
    var responseDataType: DataType { get }
}
