//
//  RecipeAPI.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 06/08/23.
//

import Foundation
import Alamofire

enum DataError: Error {
    case networkingError(String)
    case coreDataError(String)
}

typealias RecipeAPIResponse = (Swift.Result<RecipeResponse?, DataError>) -> Void
typealias RecipeListResponse = (Swift.Result<[Recipe], DataError>) -> Void

protocol RecipeAPI {
    func searchRecipe(textQuery: String, completion: @escaping (RecipeListResponse))
}

class RecipeAPILogic: RecipeAPI {
    
    static let shared = RecipeAPILogic()
    
    /// Recipe API URL returning list of recipe with details
    private struct Constants {
        static let apiKey = "46c0c93f"
        static let apiToken = "381bb662929a7881cd7067fc5de9d6f0"
        static let languageLocale = "en-US"
        // base urls
        static let recipeURLBase = "https://api.edamam.com/api/recipes/v2"
        static let apiRecipeQuery = "?type=public&q="
        
        static let searchQuery = "(searchQuery)"
        
        // rest apis
        static let recipeSearch = recipeURLBase + apiRecipeQuery + searchQuery + "&app_id=" + apiKey + "&app_key=" + apiToken
        
        // params and types
        // TODO: pagination
        static let pageValue = 1
    }
    
    func searchRecipe(textQuery: String, completion: @escaping (RecipeListResponse)) {
        URLCache.shared.removeAllCachedResponses()

        AF.request(Constants.recipeSearch.replacingOccurrences(of: Constants.searchQuery, with: textQuery),
                   method: .get,
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: RecipeResponse.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(.networkingError(error.localizedDescription)))
            case .success(let recipeResponse):
                if let recipesList = recipeResponse.hits?.map({ hit in
                    var recipe: Recipe = hit.recipe
                    recipe.id = UUID()
                    return recipe
                }) {
                    completion(.success(recipesList))
                } else {
                    completion(.success([]))
                }
            }
        }
    }
}
