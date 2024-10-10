//
//  CharacterDetailFeature.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 9/10/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct CharacterDetailFeature {
    
    @Dependency(\.characterService) var characterService
    @Dependency(\.episodeService) var episodeService
    
    @ObservableState
    struct State: Equatable {
        var character: RickCardsMorty.Character
        var episode: Episode?
        var isLoadingPage = false
        var characters: [RickCardsMorty.Character] = []
        
        public init(character: RickCardsMorty.Character) {
            self.character = character
        }
    }
    
    @CasePathable
    enum Action: BindableAction {
        case loadEpisodeDetails
        case processEpisode(Episode)
        case processCharacters([RickCardsMorty.Character])
        case loadCharactersEpisode
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .loadEpisodeDetails:
                guard  !state.character.episode.isEmpty,
                        let episodeUrl = state.character.episode.first,
                       let idEpisodeSubStr = episodeUrl.split(separator: "/").last,
                       let id = Int(String(idEpisodeSubStr)) else {
                    return .none
                }
                
                state.isLoadingPage = true
                
                return .run { send in
                    let episode = try await episodeService.fetchEpisodes(id: id)
                    await send(.processEpisode(episode))
                }
                
            case .processEpisode(let episode):
                state.episode = episode
                state.isLoadingPage = false
                
            case .loadCharactersEpisode:
                guard let episode = state.episode else {
                    return .none
                }
                
                state.isLoadingPage = true
                
                var ids: [String] = []
                episode.charactersURL.forEach({ characterUrl in
                    if let id = characterUrl.split(separator: "/").last {
                        ids.append(String(id))
                    }
                })
                
                return .run { [ids] send in
                    let characters = try await characterService.fectchCharaters(ids: ids)
                    await send(.processCharacters(characters))
                }
            case .processCharacters(let characters):
                state.characters = characters
                state.isLoadingPage = false
                
            case .binding:
                return .none
                
            }
            
            return .none
        }
    }
}
