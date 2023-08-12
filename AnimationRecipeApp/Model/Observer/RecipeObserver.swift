//
//  RecipeObserver.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 07/08/23.
//

import SwiftUI
import Observation

enum RecipeStateList {
    case isLoading
    case isEmpty
    case hasList
}

@Observable
class RecipeObserver {
    var recipeStateList: RecipeStateList = .isLoading
    var recipeList: [Recipe] = []
    var recipeListData: [Recipe] = []
    
    func recipeListTask(isFavorite: Bool, recipes: [FavoriteRecipes]) {
        if isFavorite {
            setFavValues(recipes: recipes)
        } else {
            recipeStateList = .isLoading
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
    
    // DragGestures
    func onChanged(value: DragGesture.Value, index: Int, isFavorite: Bool, isDragging: GestureState<Bool>) {
        Task {
            if value.translation.width < 0 && isDragging.wrappedValue {
                if isFavorite {
                    recipeListData[index].offset = value.translation.width
                } else {
                    recipeList[index].offset = value.translation.width
                }
            }
        }
    }
    
    func onEnded(value: DragGesture.Value, index: Int, isFavorite: Bool) {
        withAnimation {
            if isFavorite {
                if -value.translation.width >= 60 {
                    recipeListData[index].offset = -80
                } else {
                    setDefaultOffset(index: index, isFavorite: isFavorite)
                }
            } else {
                if -value.translation.width >= 60 {
                    recipeList[index].offset = -80
                } else {
                    setDefaultOffset(index: index, isFavorite: isFavorite)
                }
            }
        }
    }
    
    func setDefaultOffset(index: Int, isFavorite: Bool) {
        if isFavorite {
            recipeListData[index].offset = 0
        } else {
            recipeList[index].offset = 0
        }
    }
}
