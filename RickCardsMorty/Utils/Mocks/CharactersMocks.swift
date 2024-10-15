//
//  CharactersMocks.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 15/10/24.
//

import Foundation

#if DEBUG
public enum CharactersMocks {
    public static func characterMock() -> RickCardsMorty.Character {
         RickCardsMorty.Character(
            id: 1,
            name: "Rick",
            status: .alive,
            species: "Human",
            gender: .unknown,
            imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            origin: .init(name: "Earth"),
            location: .init(name: "Earth C-132"),
            episode: ["1"]
        )
    }
}
#endif
