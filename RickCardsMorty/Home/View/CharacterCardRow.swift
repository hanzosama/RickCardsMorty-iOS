//
//  CardRow.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import SwiftUI

struct CharacterCardRow: View {
    
    private var character:Character
    @Environment(\.mainFont) var mainFont
    @Environment(\.colorScheme) var colorScheme
    
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
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 10, height: 10, alignment: .center)
                    Text("\(character.status.rawValue) - \(character.species)")
                        .font(Font.custom(mainFont, size: 18))
                        .foregroundColor(colorScheme == .light ? .white: .black)
                }
            }
        }
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
    }
    
    
    var statusColor: Color {
        switch character.status {
        case .alive:
            return  Color.green
        case .dead:
            return Color.red
        case .unknown:
            return Color.gray
        }
    }
}

#if DEBUG

struct CharacterCardRow_Previews: PreviewProvider {
    static var previews: some View {
        let character = Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: "Male", imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        CharacterCardRow(character)
            .preferredColorScheme(.light)
    }
}

#endif
