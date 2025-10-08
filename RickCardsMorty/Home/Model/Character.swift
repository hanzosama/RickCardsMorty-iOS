//
//  Character.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import Foundation

public struct CharacterResponse: Decodable, Equatable {
    var info: Info
    var results: [Character]
}

public enum CharacterStatus: String, Decodable, Equatable {
    case alive = "Alive"
    case unknown = "unknown"
    case dead = "Dead"
}

public enum CharacterGender: String, Decodable, Equatable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

public struct CharacterOrigin: Decodable, Equatable {
    var name: String
}

public struct CharacterLocation: Decodable, Equatable {
    var name: String
}

public struct Character: Decodable, Equatable {
    var id: Int
    var name: String
    var status: CharacterStatus
    var species: String
    var gender: CharacterGender
    var imageUrl: String
    var origin: CharacterOrigin
    var location: CharacterLocation
    var episode: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case imageUrl = "image"
        case species = "species"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
        case episode = "episode"
    }
    
}

public struct Episode: Decodable, Equatable {
    var id: Int
    var name: String
    var episode: String
    var airDate: String
    var charactersURL: [String]
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case episode = "episode"
        case airDate = "air_date"
        case charactersURL = "characters"
    }
}

public struct Info: Decodable, Equatable {
    var pages: Int
}
