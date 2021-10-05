//
//  HomeView.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import SwiftUI
import SwiftUIX

struct HomeView: View {
    //TODO: Handle the injection later
    @StateObject var viewModel = HomeViewModel(service: CharacterService())
    @EnvironmentObject var authViewModel : AuthenticationViewModel
    @Environment(\.mainFont) var mainFont
    @Environment(\.colorScheme) var colorScheme
    
    @State private var scrollViewOffset:CGFloat = 0
    @State private var startScrollViewOffset:CGFloat = 0
    
    private var scrollTreshold:CGFloat = 450.0
    private var topID = "ScrollTop"
    private var bgColor = Color("generalBgColor")
    
    var body: some View {
        ZStack { // This is due to issue with the Activity indicator navigation
            NavigationView{
                ZStack{
                    bgColor.ignoresSafeArea()
                    
                    ScrollViewReader{ proxy in // To handle the scroll movement
                        ScrollView {
                            LazyVStack{
                                ForEach(viewModel.characters, id: \.id) { character in
                                    NavigationLink(destination:CharacterDetail(character:character)) {
                                        CharacterCardRow(character)
                                            .onAppear {
                                                viewModel.loadMoreCharacteres(currentCharater: character)
                                            }
                                            .padding(.all,10)
                                    }
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
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                            })
                            .padding(.trailing)
                            .padding(.bottom, getSafeArea().bottom == 0 ? 10 : 0)
                            //Hide or show the button according to the scrolloffset
                            .opacity(-scrollViewOffset > scrollTreshold ? 1 : 0)
                            .animation(.easeInOut)
                            ,alignment: .bottomTrailing
                        )
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .navigationSearchBar {
                            //This is a custom search bar from SwiftUIX
                            SearchBar("Search Friends",
                                      text: $viewModel.queryString,
                                      isEditing: $viewModel.isEditing) {
                                // Do something on enter
                                viewModel.reset()
                                viewModel.loadCharacters()
                            }
                            .onCancel {
                                // Do something on cancel
                                viewModel.reset()
                                viewModel.queryString = ""
                                viewModel.loadCharacters()
                                withAnimation(.spring()) {
                                    proxy.scrollTo(topID,anchor: .top)
                                }
                                
                            }
                            .textFieldBackgroundColor(colorScheme == .light ? .white : .clear)
                            .searchBarStyle(.default)
                            
                        }
                        
                    }
                }
                
                .navigationTitle("RickCardsMorty")
                .navigationBarItems(trailing:
                                        HStack {
                                            Button(action: {
                                                withAnimation {
                                                    authViewModel.signOut()
                                                }
                                            }, label: {
                                                Image(systemName: "arrow.forward")
                                                    .frame(width: 60,height: 30)
                                                    .background(Color.red)
                                                    .cornerRadius(5)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                                            }
                                            )
                                        }
                                        .foregroundColor(.white)
                )
                
            }
            
            .navigationBarColor(backgroundColor: UIColor(bgColor), tintColor:  .white, titleFontName: mainFont, largeTitleFontName: mainFont)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear{
                viewModel.loadCharacters()
            }
            
            ActivityIndicator(show: $viewModel.isLoadingPage)
                .padding(.all, 150)
            
            if !viewModel.isEditing {
                GeometryReader{ geometry -> Color in //Little trick to handle the keyboard
                    hideKeyboard()
                    return Color.clear //Just to conform Content required
                }
                .frame(width: 0, height: 0)
            }
            
        }
        
    }
}

#if DEBUG

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeView().environment(\.colorScheme, .dark)
    }
}

#endif
