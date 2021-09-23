//
//  HomeView.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import SwiftUI

struct HomeView: View {
    //TODO: Handle the injection later
    @StateObject var viewModel = HomeViewModel(service: CharacterService())
    @State private var scrollViewOffset:CGFloat = 0
    @State private var startScrollViewOffset:CGFloat = 0
    private var scrollTreshold:CGFloat = 450.0
    private var topID = "ScrollTop"
    
    var body: some View {
        ZStack { // This is due to issue with the Activity indicator navigation
            NavigationView{
                ScrollViewReader{ proxy in // To handle the scroll movement
                    ScrollView {
                        LazyVStack{
                            ForEach(viewModel.characters, id: \.id) { character in
                                Text(character.name)
                                    .onAppear {
                                        viewModel.loadMoreCharacteres(currentCharater: character)
                                    }
                                    .padding(.all,50)
                            }
                        }
                        .id(topID)
                        .overlay(
                            // Calculating Scrollview Offset
                            GeometryReader{ geometry -> Color in
                                DispatchQueue.main.async {
                                    let offset = geometry.frame(in: .global).minY
                                    if startScrollViewOffset == 0 {
                                        self.startScrollViewOffset = offset
                                    }
                                    self.scrollViewOffset = offset - startScrollViewOffset
                                    
                                }
                                return Color.clear //Just to conform Content required
                            }
                            .frame(width: 0, height: 0)
                            ,alignment: .top
                        )
                    }
                    .overlay(
                        Button(action: { //Movement animation
                            withAnimation(.spring()) {
                                proxy.scrollTo(topID,anchor: .top)
                            }
                        }, label: {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                        })
                        .padding(.trailing)
                        .padding(.bottom, getSafeArea().bottom == 0 ? 10 : 0)
                        //Hide or show the button according to the scrolloffset
                        .opacity(-scrollViewOffset > scrollTreshold ? 1 : 0)
                        .animation(.easeInOut)
                        ,alignment: .bottomTrailing
                    )
                    
                }
            }.onAppear{
                viewModel.loadCharacters()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            ActivityIndicator(show: $viewModel.isLoadingPage)
                .padding(.all, 150)
        }
        
    }
}

#if DEBUG

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeView()
    }
}

#endif
