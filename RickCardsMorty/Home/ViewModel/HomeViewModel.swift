//
//  HomeViewModel.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 22/09/21.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    @Published var characters = [Character]()
    @Published var isLoadingPage = false
    @Published var queryString = ""
    @Published var isEditing = false
    
    var subscription: Set<AnyCancellable> = []
    
    private var currentPage = 1
    private var canLoadMorePages = true
    
    private var service: CharacterServiceProtocol
    
    init(service: CharacterServiceProtocol) {
        self.service = service
        $queryString.debounce(for: .milliseconds(800), scheduler: RunLoop.main) // debounces the string publisher, such that it delays the process of sending request to remote server.
            .removeDuplicates()
            .map({ [weak self] (string) -> Void in
                if string.count < 1 {
                    self?.reset()
                }
            }).sink(receiveValue: {  [weak self] _ in
                self?.reset()
                self?.loadCharacters()
                self?.isEditing = false
            })
            .store(in: &subscription)
    }
    
    func loadMoreCharacteres(currentCharater item: Character){
        //The threshold of the number of items before to request more
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        //If the current item is near to current threshold
        if characters.firstIndex(where: { $0.id == item.id}) == thresholdIndex{
            loadCharacters()
        }
    }
    
    func loadCharacters(){
        guard !isLoadingPage && canLoadMorePages else{
            return
        }
        
        isLoadingPage = true
        
        if queryString.isEmpty {
            
            service.fectchCharaters(at: currentPage)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput:{ response in
                    self.canLoadMorePages = self.currentPage < response.info.pages
                    self.isLoadingPage = false
                    self.currentPage += 1
                },receiveCompletion: { complation in
                    switch complation{
                    case .failure(_):
                        fallthrough
                    case .finished:
                        self.isLoadingPage = false
                        
                    }
                })
                .map { reponse in
                    //adding the object to the publisher
                    return self.characters + reponse.results
                }.catch { _ in
                    //Transfort in object insted of handling the error
                    Just([])
                }.assign(to: &$characters)
        }else{
            
            service.fectchCharaters(like: queryString, at: currentPage)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput:{ response in
                    self.canLoadMorePages = self.currentPage < response.info.pages
                    self.currentPage += 1
                },receiveCompletion: { complation in
                    switch complation{
                    case .failure(_):
                        fallthrough
                    case .finished:
                        self.isLoadingPage = false
                        
                    }
                })
                .map { reponse in
                    //adding the object to the publisher
                    return self.characters + reponse.results
                }.catch { _ in
                    //Transfort in object insted of handling the error
                    Just([])
                }.assign(to: &$characters)
        }
        
    }
    
    func reset(){
        
        self.canLoadMorePages = true
        self.currentPage = 1
        self.characters.removeAll()
        
    }
    
}
