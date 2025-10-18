//
//  CharacterView.swift
//  RickCardsMorty
//
//  Created by Jhoan Mauricio Vivas Rubiano on 17/10/25.
//

import SwiftUI

struct CharacterView: View {
    
    private var character: RickCardsMorty.Character
    @Environment(\.mainFont) var mainFont
    @Environment(\.colorScheme) var colorScheme
    
    init(_ character: RickCardsMorty.Character) {
        self.character = character
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 20)
            
            RemoteImage(
                stringURL: character.imageUrl,
                imagePlaceholder: { Text("Loading ...").foregroundColor(colorScheme == .light ? .white: .black) },
                image: { Image(uiImage: $0).resizable() }
            )
            .aspectRatio(contentMode: .fill)
            
            VStack(alignment: .center) {
                Text(character.name)
                    .font(Font.custom(mainFont, size: 24))
                    .bold()
                    .foregroundColor(.blue)
                    .minimumScaleFactor(10)
                    .scaledToFit()
            }
            
            Spacer()
                .frame(height: 20)
        }
    }
}

#Preview {
    let character = CharactersMocks.characterMock()

    return CharacterView(character)
        .preferredColorScheme(.dark)
}
