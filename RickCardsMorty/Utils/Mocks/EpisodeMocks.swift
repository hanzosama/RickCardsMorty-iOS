//
//  EpisodeMocks.swift
//  RickCardsMorty
//
//  Created by Claude Code
//

import Foundation

#if DEBUG
public enum EpisodeMocks {
    public static func episodeMock(
        id: Int = 1,
        name: String = "Pilot",
        episode: String = "S01E01",
        airDate: String = "December 2, 2013",
        charactersURL: [String] = [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2",
            "https://rickandmortyapi.com/api/character/3"
        ]
    ) -> Episode {
        Episode(
            id: id,
            name: name,
            episode: episode,
            airDate: airDate,
            charactersURL: charactersURL
        )
    }

    public static func episodeMockWithCharacterIds(_ characterIds: [Int]) -> Episode {
        let charactersURL = characterIds.map { "https://rickandmortyapi.com/api/character/\($0)" }
        return episodeMock(charactersURL: charactersURL)
    }
}
#endif
