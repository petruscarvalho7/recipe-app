//
//  FavoriteEmptyView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 07/08/23.
//

import SwiftUI

struct FavoriteEmptyView: View {
    var body: some View {
        VStack {
            LinearGradient(
                colors: [.teal, .pink, .blue, .yellow],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                Text("No favorites have been added yet. Tap the heart on an 'Recipe Details Screen' to add it to your favorites!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
            )
            .frame(height: 100)
//            LoadingView()
//                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                
        }
        .frame(height: 500)
        .padding(20)
    }
}

struct FavoriteEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteEmptyView()
    }
}

