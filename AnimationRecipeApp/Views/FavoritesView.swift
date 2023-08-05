//
//  FavoritesScreen.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Favorites")
        }
        .padding()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

