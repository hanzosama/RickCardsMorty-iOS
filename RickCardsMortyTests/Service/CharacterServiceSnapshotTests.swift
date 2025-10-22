//
//  CharacterServiceSnapshotTests.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 22/10/25.
//
import Testing

import SnapshotTesting
import SnapshotTestingCustomDump
import ComposableArchitecture
@testable import RickCardsMorty

@MainActor
@Suite(.snapshots(record: .failed))
struct CharacterServiceSnapshotTests {
    @Test("Character from fetchCharacters ")
    func characterResponseDefaultTest() async throws {
        // This validate current structure, if the entity change, this will throw an error
        let response = try await CharacterService.testValue.fetchCharacters(1)
        
        assertSnapshot(of: response, as: .json, record: false)
        
    }
}
