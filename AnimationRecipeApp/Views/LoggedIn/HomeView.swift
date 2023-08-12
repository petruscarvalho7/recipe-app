//
//  HomeView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//

import SwiftUI
import SwiftData

protocol RecipeDelegate {
    func saveFavRecipe(recipe: Recipe?)
    func removeFavRecipe(favRecipeData: FavoriteRecipes?)
}

struct HomeView: View {
    // SwiftData
    @Environment(\.modelContext) private var context
    
    @Environment(ModelObserver.self) var model: ModelObserver
    @Environment(RecipeObserver.self) var recipeModel: RecipeObserver
    
    @Namespace var namespace
    
    @State var showStatusBar = true
    @State var selectedIndex = 0
    @State var hasScrolled = false
    @State var showCourse = false
    @State var selectedID = UUID()
    @State var show = false
    @State var isFavorite = false
    @State var title = "Home"
    @Query var recipes: [FavoriteRecipes]
    
    @GestureState var isDragging = false
    
    var body: some View {
        let recipeList = getListData()
        ZStack {
            Color("Background")
                .ignoresSafeArea()
           
            ScrollView(showsIndicators: false) {
                scrollDetection
                
                switch recipeModel.recipeStateList {
                case .isLoading:
                    RecipeEmptyList()
                case .isEmpty:
                    if isFavorite {
                        FavoriteEmptyView()
                    }
                case .hasList:
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
                    recipeModel.setFavValues(recipes: recipes)
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
        .onAppear {
            recipeModel.recipeListTask(isFavorite: isFavorite, recipes: recipes)
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

// subviews
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
        let recipeList = getListData()
        return ForEach(recipeList.indices, id: \.self) { index in
            let recipeExists = hasFavorite(recipeList: recipeList, index)
            let favRecipe = isFavorite
                ? isFavorite
                : recipeExists.isEmpty == false
            ZStack {
                Color(favRecipe ? Color.red.opacity(0.8) : Color.green.opacity(0.7))
                    .cornerRadius(30)
                
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            if favRecipe {
                                removeFavRecipe(favRecipeData: recipeExists.first)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    recipeModel.setDefaultOffset(index: index, isFavorite: isFavorite)
                                }
                            } else {
                                saveFavRecipe(recipe: recipeList[index])
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    recipeModel.setDefaultOffset(index: index, isFavorite: isFavorite)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: favRecipe ? "suit.heart.fill" : "suit.heart")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 65)
                            .vSpacing()
                    }

                }
                RecipeItem(show: $show, namespace: namespace, recipe: recipeList[index])
                    .onTapGesture {
                        if recipeList[index].offset == 0 {
                            withAnimation(.openCard.delay(0.3)) {
                                model.showDetail.toggle()
                                showStatusBar = false
                                selectedID = recipeList[index].id!
                                show.toggle()
                            }
                        }
                    }
                    // drag gesture
                    .offset(x: recipeList[index].offset!)
                    .animation(.easeInOut(duration: 0.45), value: recipeList[index].offset)
                    .gesture(DragGesture()
                        .updating($isDragging, body: { (value, state, _) in
                            state = true
                            
                            recipeModel.onChanged(value: value, index: index, isFavorite: isFavorite, isDragging: $isDragging)
                        }).onEnded({ value in
                            recipeModel.onEnded(value: value, index: index, isFavorite: isFavorite)
                        })
                    )
            }
        }
    }
    
    var detail: some View {
        let recipeList = getListData()
        return ForEach(recipeList.indices, id: \.self) { index in
            if recipeList[index].id == selectedID {
                let recipeExists = hasFavorite(recipeList: recipeList, index)
                let favRecipe = isFavorite
                    ? isFavorite
                    : recipeExists.isEmpty == false
                RecipeDetailsView(show: $show,
                                  isFavorite: favRecipe,
                                  favRecipeData: favRecipe && recipes.count > 0
                                    ? recipeExists.first
                                    : nil,
                                  delegate: self,
                                  recipe: recipeList[index],
                                  namespace: namespace
                )
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.3)),
                        removal: .opacity.animation(.easeInOut(duration: 0.4).delay(0.3))))
            }
        }
    }
}

// aux methods
extension HomeView {
    fileprivate func getListData() -> [Recipe] {
        return isFavorite ? recipeModel.recipeListData : recipeModel.recipeList
    }
    
    fileprivate func hasFavorite(recipeList: [Recipe], _ i: Array<Recipe>.Index) -> [FavoriteRecipes] {
        return recipes.filter { $0.label == recipeList[i].label }
    }
}

extension HomeView: RecipeDelegate {
    func saveFavRecipe(recipe: Recipe?) {
        do {
            guard var recipeData = recipe else { return }
            recipeData.offset = 0
            let favRecipe = FavoriteRecipes(recipe: recipeData)
            // Insert a new recipe
            context.insert(favRecipe)
            try context.save()
        } catch { print(error) }
    }
    
    func removeFavRecipe(favRecipeData: FavoriteRecipes?) {
        // Delete recipe
        if let favToDelete = favRecipeData {
            context.delete(favToDelete)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(ModelObserver())
            .environment(RecipeObserver())
    }
}
