//
//  HomeFeatureTests.swift
//  RickCardsMortyTests
//
//  Created by Jhoan Mauricio Vivas Rubiano on 28/10/24.
//

import Testing
import ComposableArchitecture

@testable import RickCardsMorty

@MainActor
@Suite("HomeFeature Tests")
struct HomeFeatureTests {

    @Test("Load characters successfully")
    func loadCharactersSuccess() async {
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

    @Test("Load characters when already loading should not trigger")
    func loadCharactersWhenAlreadyLoading() async {
        let store = TestStore(
            initialState: HomeFeature.State(isLoadingPage: true),
            reducer: HomeFeature.init
        )

        // Should not trigger another load when already loading
        await store.send(.loadCharacters)
    }

    @Test("Load characters when no more pages available")
    func loadCharactersWhenNoMorePages() async {
        let store = TestStore(
            initialState: HomeFeature.State(canLoadMorePages: false),
            reducer: HomeFeature.init
        )

        // Should not trigger load when no more pages available
        await store.send(.loadCharacters)
    }

    @Test("Load more characters triggers at threshold")
    func loadMoreCharactersTrigger() async {
        // Create 10 characters to test threshold
        let characters = CharactersMocks.charactersMock(count: 10)

        let store = TestStore(
            initialState: HomeFeature.State(characters: characters),
            reducer: HomeFeature.init
        )

        let responseMock = CharactersMocks.characterResponseMock()

        // Trigger load more with the 6th character (threshold is at index 5, which is 10 - 5)
        await store.send(.loadMoreCharacters(characters[5]))

        // loadMoreCharacters sends .loadCharacters when at threshold
        await store.receive(\.loadCharacters) {
            $0.isLoadingPage = true
        }

        await store.receive(\.processResponse) {
            $0.isLoadingPage = false
            $0.canLoadMorePages = false
            $0.currentPage = 2
            $0.characters = characters + responseMock.results
        }
    }

    @Test("Load more characters does not trigger when not at threshold")
    func loadMoreCharactersNoTrigger() async {
        // Create 10 characters
        let characters = CharactersMocks.charactersMock(count: 10)

        let store = TestStore(
            initialState: HomeFeature.State(characters: characters),
            reducer: HomeFeature.init
        )

        // Should not trigger load with a character that's not at threshold (index 7, not 5)
        await store.send(.loadMoreCharacters(characters[7]))
    }

    // Note: Debounce tests are complex with TCA's scheduler system
    // and would require proper TestScheduler setup which is version-specific.
    // These tests verify the basic functionality without timing concerns.

    @Test("Reset data clears state correctly")
    func resetData() async {
        let characters = [CharactersMocks.characterMock()]

        let store = TestStore(
            initialState: HomeFeature.State(
                characters: characters,
                isLoadingPage: true,
                currentPage: 3,
                canLoadMorePages: false
            ),
            reducer: HomeFeature.init
        )

        await store.send(.resetData) {
            $0.isLoadingPage = false
            $0.canLoadMorePages = true
            $0.currentPage = 1
            $0.characters = []
        }
    }

    @Test("Empty search updates loading state")
    func emptySearch() async {
        let store = TestStore(
            initialState: HomeFeature.State(isLoadingPage: true),
            reducer: HomeFeature.init
        )

        await store.send(.emptySearch) {
            $0.isLoadingPage = false
        }
    }

    @Test("Character selection presents detail view")
    func characterSelected() async {
        let character = CharactersMocks.characterMock()

        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: HomeFeature.init
        )

        await store.send(.characterSelected(character)) {
            $0.cardDetail = CharacterDetailFeature.State(character: character)
        }
    }

    @Test("Process response with multiple pages enables pagination")
    func processResponseWithMultiplePages() async {
        let store = TestStore(
            initialState: HomeFeature.State(isLoadingPage: true),
            reducer: HomeFeature.init
        )

        let responseWithMorePages = CharacterResponse(
            info: Info(pages: 5),
            results: [CharactersMocks.characterMock()]
        )

        await store.send(.processResponse(response: responseWithMorePages)) {
            $0.isLoadingPage = false
            $0.isEditingText = false
            $0.canLoadMorePages = true  // currentPage (1) < pages (5)
            $0.currentPage = 2
            $0.characters = responseWithMorePages.results
        }
    }

    @Test("Process response on last page disables pagination")
    func processResponseLastPage() async {
        let store = TestStore(
            initialState: HomeFeature.State(isLoadingPage: true, currentPage: 5),
            reducer: HomeFeature.init
        )

        let responseLastPage = CharacterResponse(
            info: Info(pages: 5),
            results: [CharactersMocks.characterMock()]
        )

        await store.send(.processResponse(response: responseLastPage)) {
            $0.isLoadingPage = false
            $0.isEditingText = false
            $0.canLoadMorePages = false  // currentPage (5) is not < pages (5)
            $0.currentPage = 6
            $0.characters = responseLastPage.results
        }
    }

    @Test("Load characters handles errors gracefully")
    func loadCharactersErrorHandling() async {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: HomeFeature.init
        ) {
            $0.characterService.fetchCharacters = { _ in
                struct TestError: Error {}
                throw TestError()
            }
        }

        await store.send(.loadCharacters) {
            $0.isLoadingPage = true
        }

        await store.receive(\.emptySearch) {
            $0.isLoadingPage = false
        }
    }

}
