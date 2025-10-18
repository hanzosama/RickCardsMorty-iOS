//
//  CharactersMocks.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 15/10/24.
//

import Foundation

#if DEBUG
public enum CharactersMocks {
    public static func characterMock(
        id: Int = 1,
        name: String = "Rick",
        status: CharacterStatus = .alive,
        species: String = "Human",
        gender: CharacterGender = .unknown
    ) -> RickCardsMorty.Character {
        RickCardsMorty.Character(
            id: id,
            name: name,
            status: status,
            species: species,
            gender: gender,
            imageUrl: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg",
            origin: .init(name: "Earth"),
            location: .init(name: "Earth C-132"),
            episode: ["1"]
        )
    }

    public static func charactersMock(count: Int) -> [RickCardsMorty.Character] {
        (1...count).map { id in
            characterMock(
                id: id,
                name: "Character \(id)",
                status: .alive,
                species: "Human",
                gender: .male
            )
        }
    }

    public static func characterResponseMock() -> CharacterResponse {
        CharacterResponse(
            info: Info.init(pages: 1),
            results: [characterMock()]
        )
    }
}
#endif
