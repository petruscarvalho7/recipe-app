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
            LinearGradient(
                colors: [.teal, .pink, .blue, .yellow],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                Text("Loading...")
                    .font(Font.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
            )
            .frame(height: 100)
            LoadingView()
                .frame(height: 100)
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

