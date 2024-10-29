//
//  HomeFeatureTests.swift
//  RickCardsMortyTests
//
//  Created by Jhoan Mauricio Vivas Rubiano on 28/10/24.
//

import XCTest

import ComposableArchitecture

@testable import RickCardsMorty

class HomeFeatureTests: XCTestCase {

    @MainActor
    func testHomeFeatureBasic() async {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: HomeFeature.init
        )
        
        let responseMock = CharactersMocks.characterResponseMock()
        
        await store.send(.loadCharacters) {
            $0.isLoadingPage = true
            $0.characters = []
        }
        
        await store.receive(\.processResponse) {
            $0.isLoadingPage = false
            $0.canLoadMorePages = false
            $0.currentPage = 2
            $0.characters = responseMock.results
        }
    }

}
