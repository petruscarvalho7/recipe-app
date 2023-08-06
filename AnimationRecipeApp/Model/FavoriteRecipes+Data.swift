//
//  FavoriteRecipes+Data.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 06/08/23.
//

import Foundation
import SwiftData

@Model
class FavoriteRecipes {
    var id: UUID
    @Attribute(.unique) var label: String
    var recipeJSON: String
    
    init(recipe: Recipe) {
        self.id = recipe.id!
        self.label = recipe.label
        do {
            let jsonData = try JSONEncoder().encode(recipe)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            self.recipeJSON = jsonString
        } catch {
            print(error)
            self.recipeJSON = ""
        }
    }
    
    func getRecipe() -> Recipe? {
        do {
            // Decode
            let decodedRecipe = try JSONDecoder().decode(Recipe.self, from: self.recipeJSON.data(using: .utf8)!)
            return decodedRecipe
        } catch {
            print(error)
            return nil
        }
    }
}
