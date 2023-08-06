//
//  HomeView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var model: ModelObserver
    @Namespace var namespace
    @State var showStatusBar = true
    @State var selectedIndex = 0
    @State var hasScrolled = false
    @State var showCourse = false
    @State var selectedID = UUID()
    @State var show = false
    @State var isFavorite = false
    @State var title = "Home"
    @State var recipeList: [Recipe] = []
    @Query var recipes: [FavoriteRecipes]
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
           
            ScrollView(showsIndicators: false) {
                scrollDetection
                
                if recipeList.isEmpty {
                    LoadingView()
                } else {
                    Text("Recipes".uppercased())
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    
                    LazyVGrid(columns: [GridItem(
                        .adaptive(minimum: 300), spacing: 20)], spacing: 20) {
                        if !show {
                            cards
                        } else {
                            ForEach(recipeList) { recipe in
                                Rectangle()
                                    .fill(.white)
                                    .frame(height: 300)
                                    .cornerRadius(30)
                                    .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                                    .opacity(0.3)
                                    .padding(.horizontal, 30)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onChange(of: recipes.count) {
                if isFavorite {
                    setFavValues()
                }
            }
            .coordinateSpace(name: "scroll")
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 70)
            })
            .overlay(
                NavigationBar(hasScrolled: $hasScrolled, title: title)
            )
            
            if show, !recipeList.isEmpty {
                detail
            }
        }
        .task {
            if isFavorite {
                if (!recipes.isEmpty) {
                    setFavValues()
                } else {
                    self.recipeList = []
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.fetchRecipeList()
                }
            }
        }
        .statusBarHidden(!showStatusBar)
        .onChange(of: show) { oldState, newState in
            withAnimation(.closeCard) {
                if newState {
                    showStatusBar = false
                } else {
                    showStatusBar = true
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ModelObserver())
    }
}

// fetch data
extension HomeView {
    func fetchRecipeList(searchText: String = "pasta") {
        RecipeAPILogic.shared.searchRecipe(textQuery: searchText) { [self] result in
            switch result {
            case .success(let recipesList):
                self.recipeList = recipesList
            case .failure(_): break
                // TODO: failure flow
            }
        }
    }
}

extension HomeView {
    var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: ScrollPreferenceKey.self,
                value: proxy.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    hasScrolled = true
                } else {
                    hasScrolled = false
                }
            }
        })
    }
    
    var cards: some View {
        ForEach(recipeList) { recipe in
            RecipeItem(show: $show, namespace: namespace, recipe: recipe)
                .onTapGesture {
                    withAnimation(.openCard.delay(0.3)) {
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectedID = recipe.id!
                        show.toggle()
                }
            }
        }
    }
    
    var detail: some View {
        ForEach(recipeList.indices, id: \.self) { i in
            if recipeList[i].id == selectedID {
                RecipeDetailsView(show: $show, isFavorite: isFavorite, favRecipeData: isFavorite && recipes.count > 0 ? recipes[i] : nil, recipe: recipeList[i], namespace: namespace)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.3)),
                        removal: .opacity.animation(.easeInOut(duration: 0.4).delay(0.3))))
            }
        }
    }
}

extension HomeView {
    private func setFavValues() {
        self.recipeList = recipes.compactMap({ favoriteRecipe in
            if let recipe = favoriteRecipe.getRecipe() {
                return recipe
            }
            return nil
        })
    }
}
