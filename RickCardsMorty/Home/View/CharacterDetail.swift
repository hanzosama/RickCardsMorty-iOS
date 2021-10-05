//
//  CharacterDetail.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 4/10/21.
//

import SwiftUI

struct CharacterDetail: View {
    @StateObject var viewModel = CharacterDetailViewModel(service: EpisodeService(),characterService: CharacterService())
    @Environment(\.mainFont) var mainFont
    @Environment(\.colorScheme) var colorScheme
    
    
    var character: Character
    var body: some View {
        ZStack{
            Color("cardColor").edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                if viewModel.episode != nil, let episode = viewModel.episode {
                    Text(episode.name)
                        .font(Font.custom(mainFont, size: 24))
                        .bold()
                        .foregroundColor(colorScheme == .light ? .white: .black)
                        .frame(maxWidth:.infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .onAppear(perform: {
                            viewModel.loadCharactersEpisode()
                        })
                    
                    Text("Episode - \(episode.episode)")
                        .font(Font.custom(mainFont, size: 24))
                        .bold()
                        .foregroundColor(colorScheme == .light ? .white: .black)
                        .frame(maxWidth:.infinity, alignment: .center)
                    
                    Text("Air Date - \(episode.airDate)")
                        .font(Font.custom(mainFont, size: 24))
                        .bold()
                        .foregroundColor(colorScheme == .light ? .white: .black)
                        .frame(maxWidth:.infinity, alignment: .center)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum:100))]) {
                            ForEach(viewModel.characters,id: \.id) { character in
                                if character.id != self.character.id {
                                    VStack{
                                        RemoteImage(stringURL:character.imageUrl,
                                                    imagePlaceholder: { Text("Loading ...").foregroundColor(colorScheme == .light ? .white: .black) }
                                                    ,image: { Image(uiImage: $0).resizable() })
                                            .width(100)
                                            .height(100)
                                            .padding(1)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                        HStack(alignment:.center){
                                            Circle()
                                                .fill(getStatusColor(character))
                                                .frame(width: 10, height: 10, alignment: .leading)
                                            Spacer()
                                            Text(character.name)
                                                .font(Font.custom(mainFont, size: 16))
                                                .foregroundColor(colorScheme == .light ? .white: .black)
                                                .frame(maxWidth:.infinity, alignment: .leading)
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
            }
            .padding()
            
            ActivityIndicator(show: $viewModel.isLoadingPage)
                .padding(.all, 150)
            
        }
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
        .padding(.all,10)
        .navigationTitle("First Episode of \(character.name)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.loadEpisodeDetails(character: character)
        }
    }
    
    func getStatusColor(_ character:Character) -> Color{
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

struct CharacterDetail_Previews: PreviewProvider {
    static var previews: some View {
        let character = Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .unknown, imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",origin: .init(name: "Earth"), location: .init(name: "Earth C-132"),episode: [])
        return  CharacterDetail(character: character)
    }
}
