//
//  CardRow.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import SwiftUI

struct CharacterCardRow: View {
    
    private var character: RickCardsMorty.Character
    @Environment(\.mainFont) var mainFont
    @Environment(\.colorScheme) var colorScheme
    
    init(_ character: RickCardsMorty.Character) {
        self.character = character
    }
    
    var body: some View {
        ZStack {
            Color("cardColor").edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                
                RemoteImage(
                    stringURL: character.imageUrl,
                    imagePlaceholder: { Text("Loading ...").foregroundColor(colorScheme == .light ? .white: .black) },
                    image: { Image(uiImage: $0).resizable() }
                )
                .padding(20)
                .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(character.name)
                        .font(Font.custom(mainFont, size: 24))
                        .bold()
                        .foregroundColor(colorScheme == .light ? .white: .black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 10, height: 10, alignment: .center)
                        Text("\(character.status.rawValue) - \(character.species)")
                            .font(Font.custom(mainFont, size: 18))
                            .foregroundColor(colorScheme == .light ? .white: .black)
                    }
                    HStack {
                        Text("Gender - ")
                            .font(Font.custom(mainFont, size: 18))
                            .foregroundColor(colorScheme == .light ? .white: .black)
                        genderImage
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(colorScheme == .light ? .white: .black)
                    }
                    HStack {
                        Text("Origin - \(character.origin.name)")
                            .font(Font.custom(mainFont, size: 18))
                            .foregroundColor(colorScheme == .light ? .white: .black)
                        
                    }
                    HStack {
                        Text("Last known location - \(character.location.name)")
                            .font(Font.custom(mainFont, size: 18))
                            .foregroundColor(colorScheme == .light ? .white: .black)
                        
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
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
    
    var genderImage: Image {
        switch character.gender {
        case .female:
            return  Image("female")
        case .male:
            return Image("male")
        case .genderless:
            return Image("noGender")
        case .unknown:
            return Image(systemName: "questionmark.square.dashed")
        }
    }
}

#Preview {
    let character = CharactersMocks.characterMock()

    return CharacterCardRow(character)
        .preferredColorScheme(.light)
}
