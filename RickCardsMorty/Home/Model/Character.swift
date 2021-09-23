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

struct Character: Decodable  {
    var id:Int
    var name:String
    var status:String
    var species:String
    var gender:String
    var imageUrl:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case imageUrl = "image"
        case species
        case gender
    }

}

struct Info: Decodable {
    var pages:Int
}
