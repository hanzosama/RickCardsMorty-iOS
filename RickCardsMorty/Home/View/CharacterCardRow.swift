//
//  CardRow.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import SwiftUI

struct CharacterCardRow: View {
    private var character:Character
    init(_ character:Character) {
        self.character = character
    }
    var body: some View {
        ZStack{
        Text("Name:"+character.name)
        }
    }
}

#if DEBUG

struct CharacterCardRow_Previews: PreviewProvider {
    static var previews: some View {
        let character = Character(id: 1, name: "Rick", status: "Live", species: "Human", gender: "Male", imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        CharacterCardRow(character)
    }
}

#endif
