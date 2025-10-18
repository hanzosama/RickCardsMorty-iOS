//
//  HomeFeature.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 9/10/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct HomeFeature {
    
    @Dependency(\.characterService) var characterService
    @Dependency(\.mainQueue) var mainQueue
    
    @ObservableState
    struct State: Equatable {
        var characters: [RickCardsMorty.Character] = []
        var isLoadingPage = false
        var isEditingText = false
        var queryString = ""
        @ObservationStateIgnored var currentPage = 1
        @ObservationStateIgnored var canLoadMorePages = true
        @Presents var cardDetail: CharacterDetailFeature.State?
    }
    
    enum Action: BindableAction {
        case loadMoreCharacters(_ currentCharacter: RickCardsMorty.Character)
        case loadCharacters
        case processResponse(response: CharacterResponse)
        case resetData
        case logoutTap
        case emptySearch
        case characterSelected(RickCardsMorty.Character)
        case cardDetail(PresentationAction<CharacterDetailFeature.Action>)
        case binding(BindingAction<State>)
    }
    
    enum CancelID { case search }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .loadMoreCharacters(let currentCharacter):
                // The threshold of the number of items before to request more
                let thresholdIndex = state.characters.index(state.characters.endIndex, offsetBy: -5)
                // If the current item is near to current threshold
                if state.characters.firstIndex(where: { $0.id == currentCharacter.id}) == thresholdIndex {
                    return .send(.loadCharacters)
                }
                
            case .loadCharacters:
                guard !state.isLoadingPage, state.canLoadMorePages else {
                    return .none
                }
                
                state.isLoadingPage = true
                let currentPage = state.currentPage
                let queryString = state.queryString
                
                return .run { send in
                    if queryString.isEmpty {
                        let response = try await characterService.fetchCharacters(currentPage)
                        await send(.processResponse(response: response))
                    } else {
                        let response = try await characterService.fetchCharactersLike(queryString, currentPage)
                        await send(.processResponse(response: response))
                    }
                } catch: { _, send in
                    print("There was an error in the search")
                    await send(.emptySearch)
                }
                
            case .processResponse(let response):
                state.canLoadMorePages = state.currentPage < response.info.pages
                state.currentPage += 1
                state.isLoadingPage = false
                state.isEditingText = false
                
                state.characters += response.results
                
            case .resetData:
                state.isLoadingPage = false
                state.canLoadMorePages = true
                state.currentPage = 1
                state.characters.removeAll()
            case .binding(\.queryString):
                
                return .run { send in
                    await send(.resetData)
                    await send(.loadCharacters)
                }
                .debounce(id: CancelID.search, for: 0.5, scheduler: self.mainQueue)
            case .emptySearch:
                state.isLoadingPage = false
            case .binding:
                break
                
            case .logoutTap:
                break
            case .cardDetail:
                break
            case .characterSelected(let character):
                state.cardDetail = CharacterDetailFeature.State(character: character)
            }
            
            return .none
        }
        .ifLet(\.$cardDetail, action: \.cardDetail) {
            CharacterDetailFeature()
        }
    }
}
