//
//  CharacterDetail.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 4/10/21.
//

import SwiftUI

import ComposableArchitecture

struct CharacterDetail: View {
    @Perception.Bindable var store: StoreOf<CharacterDetailFeature>
    
    public init(store: StoreOf<CharacterDetailFeature>) {
        self.store = store
    }
    
    @Environment(\.mainFont) var mainFont
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color("cardColor").edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    if let episode = store.episode {
                        Text(episode.name)
                            .font(Font.custom(mainFont, size: 24))
                            .bold()
                            .foregroundColor(colorScheme == .light ? .white: .black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .onAppear {
                                store.send(.loadCharactersEpisode)
                            }
                        
                        Text("Episode - \(episode.episode)")
                            .font(Font.custom(mainFont, size: 24))
                            .bold()
                            .foregroundColor(colorScheme == .light ? .white: .black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Air Date - \(episode.airDate)")
                            .font(Font.custom(mainFont, size: 24))
                            .bold()
                            .foregroundColor(colorScheme == .light ? .white: .black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                                ForEach(store.characters, id: \.id) { character in
                                    if character.id != store.character.id {
                                        VStack {
                                            RemoteImage(
                                                stringURL: character.imageUrl,
                                                imagePlaceholder: { Text("Loading ...").foregroundColor(colorScheme == .light ? .white: .black) }
                                                ,
                                                image: { Image(uiImage: $0).resizable() }
                                            )
                                            .width(100)
                                            .height(100)
                                            .padding(1)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                            HStack(alignment: .center) {
                                                Circle()
                                                    .fill(getStatusColor(character))
                                                    .frame(width: 10, height: 10, alignment: .leading)
                                                Spacer()
                                                Text(character.name)
                                                    .font(Font.custom(mainFont, size: 16))
                                                    .foregroundColor(colorScheme == .light ? .white: .black)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                }
                .padding()
                
                ActivityIndicator(show: $store.isLoadingPage)
                    .padding(.all, 150)
                
            }
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
            .padding(.all, 10)
            .navigationTitle("First Episode of \(store.character.name)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                store.send(.loadEpisodeDetails)
            }
        }
    }
    
    func getStatusColor(_ character: Character) -> Color {
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
