//
//  HomeView.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 9/09/21.
//

import SwiftUI

import ComposableArchitecture
import SwiftUIX

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    @Environment(\.mainFont) var mainFont
    @Environment(\.colorScheme) var colorScheme
    
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startScrollViewOffset: CGFloat = 0
    
    private var scrollTreshold: CGFloat = 450.0
    private var topID = "ScrollTop"
    private var bgColor = Color("generalBgColor")
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    // TODO: refactor view components to improve Hierarchy, same with the others main view.
    var body: some View {
        ZStack { // This is due to issue with the Activity indicator navigation
            NavigationStack {
                ZStack {
                    bgColor.ignoresSafeArea()
                    
                    ScrollViewReader { proxy in // To handle the scroll movement
                        ScrollView {
                            LazyVStack {
                                if !store.characters.isEmpty {
                                    ForEach(store.characters, id: \.id) { character in
                                        
                                        CharacterCardRow(character)
                                            .onAppear {
                                                store.send(.loadMoreCharacters(character))
                                            }
                                            .padding(.all, 10)
                                            .onTapGesture {
                                                store.send(.characterSelected(character))
                                            }
                                    }
                                } else {
                                    Text("There is not results... :(")
                                        .font(Font.custom(mainFont, size: 20))
                                }
                            }
                            .id(topID)
                            .overlay(
                                // Calculating Scrollview Offset
                                GeometryReader { geometry -> Color in
                                    DispatchQueue.main.async {
                                        let offset = geometry.frame(in: .global).minY
                                        if startScrollViewOffset == 0 {
                                            self.startScrollViewOffset = offset
                                        }
                                        self.scrollViewOffset = offset - startScrollViewOffset
                                    }
                                    return Color.clear // Just to conform Content required
                                }
                                .frame(width: 0, height: 0),
                                alignment: .top
                            )
                        }
                        .overlay(
                            Button(action: { // Movement animation
                                withAnimation(.spring()) {
                                    proxy.scrollTo(topID, anchor: .top)
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
                            .padding(.bottom, getSafeArea().bottom == 0 ? 10 : 0) // Hide or show the button according to the scrolloffset
                            .opacity(-scrollViewOffset > scrollTreshold ? 1 : 0)
                            .animation(.easeInOut, value: scrollViewOffset),
                            alignment: .bottomTrailing
                        )
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .navigationSearchBar {
                            // This is a custom search bar from SwiftUIX
                            SearchBar(
                                "Search Friends",
                                text: $store.queryString,
                                isEditing: $store.isEditingText
                            ) {
                                // Do something on enter
                                store.send(.resetData)
                                store.send(.loadCharacters)
                            }
                            .onCancel {
                                // Do something on cancel
                                store.send(.resetData)
                                store.queryString = ""
                                store.send(.loadCharacters)
                                withAnimation(.spring()) {
                                    proxy.scrollTo(topID, anchor: .top)
                                }
                            }
                            .textFieldBackgroundColor(colorScheme == .light ? .white : .clear)
                            .searchBarStyle(.default)
                        }
                    }
                }
                .navigationDestination(
                    item: $store.scope(
                        state: \.cardDetail,
                        action: \.cardDetail
                    )
                ) { store in
                    CharacterDetailView(store: store)
                }
                .navigationTitle("RickCardsMorty")
                .navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            store.send(.logoutTap, animation: .easeOut)
                        }, label: {
                            Image(systemName: "arrow.forward")
                                .frame(width: 60, height: 30)
                                .background(Color.red)
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                        })
                    }
                    .foregroundColor(.white)
                )
            }
            .navigationBarColor(backgroundColor: UIColor(bgColor), tintColor: .white, titleFontName: mainFont, largeTitleFontName: mainFont)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                store.send(.loadCharacters)
            }
            
            ActivityIndicator(show: $store.isLoadingPage)
                .padding(.all, 150)
            
            if !store.isEditingText {
                GeometryReader { _ -> Color in // Little trick to handle the keyboard
                    hideKeyboard()
                    return Color.clear // Just to conform Content required
                }
                .frame(width: 0, height: 0)
            }
        }
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State.init(),
            reducer: HomeFeature.init
        )
    )
}
