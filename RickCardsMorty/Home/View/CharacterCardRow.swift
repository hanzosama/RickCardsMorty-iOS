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
            Color("cardColor").edgesIgnoringSafeArea(.all)
            VStack{
                RemoteImage(stringURL:character.imageUrl,
                            imagePlaceholder: { Text("Loading ...") }
                            ,image: { Image(uiImage: $0).resizable() })
                    .padding(20)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
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
