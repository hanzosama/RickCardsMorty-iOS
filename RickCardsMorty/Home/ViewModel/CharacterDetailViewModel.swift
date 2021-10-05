//
//  CharacterDetailViewModel.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 4/10/21.
//

import Foundation
import Combine

class CharacterDetailViewModel: ObservableObject {
    
    @Published var episode:Episode?
    @Published var isLoadingPage = false
    @Published var characters:[Character] = []
    
    private var episodesService:EpisodeServiceProtocol
    private var characterService: CharacterServiceProtocol
    
    init(service: EpisodeServiceProtocol,characterService: CharacterServiceProtocol) {
        self.episodesService = service
        self.characterService = characterService
    }
    
    func loadEpisodeDetails(character:Character){
        guard  !character.episode.isEmpty ,let episodeUrl = character.episode.first, let idEpisodeSubStr = episodeUrl.split(separator: "/").last,let id = Int(String(idEpisodeSubStr)) else{
            return
        }
        
        isLoadingPage = true
        
        episodesService.fetchEpisodes(id: id)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion:{  complation in
                switch complation{
                case .failure(_):
                    fallthrough
                case .finished:
                    self.isLoadingPage = false
                }
            }).map({ reponse in
                return reponse
            })
            .catch { error in
                return Just(nil)
            }.assign(to: &$episode)
        
    }
    
    func loadCharactersEpisode(){
        if episode != nil{
            isLoadingPage = true
            var ids: [String] = []
            episode?.charactersURL.forEach({ characterUrl in
                if let id = characterUrl.split(separator: "/").last {
                    ids.append(String(id))
                }
            })
            characterService.fectchCharaters(ids: ids)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveCompletion: { complation in
                    switch complation{
                    case .failure(_):
                        fallthrough
                    case .finished:
                        self.isLoadingPage = false
                    }
                })
                .map { reponse in
                    //adding the object to the publisher
                    return reponse
                }.catch { _ in
                    //Transfort in object insted of handling the error
                    Just([])
                }.assign(to: &$characters)
            
        }
    }
    
}
