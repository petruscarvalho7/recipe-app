//
//  RecipeEmptyList.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 10/08/23.
//

import SwiftUI

struct RecipeEmptyList: View {
    var body: some View {
        VStack {
            LoadingView()
                .frame(height: 500)
            Spacer()
            
        }
        .frame(height: 500)
        .padding(20)
    }
}

struct RecipeEmptyList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEmptyList()
    }
}

