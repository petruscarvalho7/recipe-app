//
//  AnimationRecipeApp.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

@main
struct AnimationRecipeApp: App {
    @StateObject var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
