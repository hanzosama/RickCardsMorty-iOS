//
//  Request.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 13/09/21.
//

public typealias HTTPHeadersParams = [String:Any]

public enum DataType {
    case Json
    case Data
}


public enum HTTPMethod:String {
    case POST = "POST"
    case PUT = "PUT"
    case GET = "GET"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case HEAD = "HEAD"
}

public enum RequestParams {
    case body(_: [String:Any])
    case url(_: [String:Any])
}

public protocol Request{
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters: RequestParams {get}
    var headers : HTTPHeadersParams? {get}
    var responseDataType: DataType {get}
}
