//
//  Character.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import Foundation

struct CharacterResponse: Decodable{
    var info:Info
    var results:[Character]
}

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case unknown = "unknown"
    case dead = "Dead"
}

enum CharacterGender: String, Decodable{
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

struct CharacterOrigin: Decodable{
    var name:String
}

struct CharacterLocation: Decodable {
    var name:String
}

struct Character: Decodable  {
    var id:Int
    var name:String
    var status:CharacterStatus
    var species:String
    var gender:CharacterGender
    var imageUrl:String
    var origin:CharacterOrigin
    var location:CharacterLocation
    var episode:[String]
    
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


struct Episode: Decodable {
    var id:Int
    var name:String
    var episode:String
    var airDate:String
    var charactersURL:[String]
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case episode = "episode"
        case airDate = "air_date"
        case charactersURL = "characters"
    }
}

struct Info: Decodable {
    var pages:Int
}
