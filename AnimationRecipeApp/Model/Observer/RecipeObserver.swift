//
//  RecipeObserver.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 07/08/23.
//

import SwiftUI
import Combine

enum RecipeStateList {
    case isLoading
    case isEmpty
    case hasList
}

class RecipeObserver: ObservableObject {
    @Published var recipeStateList: RecipeStateList = .isLoading
    @Published var recipeList: [Recipe] = []
    @Published var recipeListData: [Recipe] = []
    
    func recipeListTask(isFavorite: Bool, recipes: [FavoriteRecipes]) {
        if isFavorite {
            setFavValues(recipes: recipes)
        } else {
            if recipeList.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.fetchRecipeList()
                }
            } else {
                recipeStateList = .hasList
            }
        }
    }
    
    func setFavValues(recipes: [FavoriteRecipes]) {
        if (!recipes.isEmpty) {
            self.recipeListData = recipes.compactMap({ favoriteRecipe in
                if let recipe = favoriteRecipe.getRecipe() {
                    return recipe
                }
                return nil
            })
            recipeStateList = .hasList
        } else {
            recipeStateList = .isEmpty
        }
    }
    
    private func fetchRecipeList(searchText: String = "pasta") {
        RecipeAPILogic.shared.searchRecipe(textQuery: searchText) { [self] result in
            switch result {
            case .success(let recipesList):
                self.recipeList = recipesList
                recipeStateList = recipesList.isEmpty ? .isEmpty : .hasList
            case .failure(_): break
                // TODO: failure flow
            }
        }
    }
}
