//
//  AnimationRecipeApp.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI
import SwiftData

@main
struct AnimationRecipeApp: App {
    @StateObject var model = ModelObserver()
    
    let modelContainer: ModelContainer
        
    init() {
        do {
            modelContainer = try ModelContainer(for: FavoriteRecipes.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        .modelContainer(modelContainer)
    }
}
