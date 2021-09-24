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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case imageUrl = "image"
        case species = "species"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
    }
    
}

struct Info: Decodable {
    var pages:Int
}
