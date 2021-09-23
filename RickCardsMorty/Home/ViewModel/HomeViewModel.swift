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
    private var currentPage = 1
    private var canLoadMorePages = true
    
    private var service: CharacterServiceProtocol
    
    init(service: CharacterServiceProtocol) {
        self.service = service
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
        
        service.fectchCharaters(at: currentPage)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput:{ response in
                self.canLoadMorePages = self.currentPage < response.info.pages
                self.isLoadingPage = false
                self.currentPage += 1
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
