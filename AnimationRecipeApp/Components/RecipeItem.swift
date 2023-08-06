//
//  RecipeItem.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//

import SwiftUI

struct RecipeItem: View {
    @Binding var show: Bool

    var namespace: Namespace.ID
    var recipe: Recipe = recipesMock[0]
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                Text(recipe.label)
                    .font(.largeTitle.weight(.bold))
                    .matchedGeometryEffect(id: "title\(recipe.label)", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(recipe.yield.description + " servings".uppercased())
                    .font(.footnote.weight(.semibold))
                    .matchedGeometryEffect(id: "subtitle\(recipe.label)", in: namespace)
                Text(recipe.getHealthLabels())
                    .font(.footnote)
                    .matchedGeometryEffect(id: "text\(recipe.label)", in: namespace)
                    .lineLimit(2)
            }
            .padding(20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .blur(radius: 30)
                    .matchedGeometryEffect(id: "blur\(recipe.label)", in: namespace)
            )
        }
        .foregroundStyle(.white)
        .background(
            AsyncImage(
                url: recipe.getImageThumbnail(),
                content: { image in
                    image
                        .resizable()
                        .frame(width: 150, height: 150)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .padding(.bottom, 120)
                        .matchedGeometryEffect(id: "image\(recipe.label)", in: namespace)
                },
                placeholder: {
                    Image("recipePlaceholder")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .padding(.bottom, 120)
                        .matchedGeometryEffect(id: "image\(recipe.label)", in: namespace)
                }
            )
        )
        .background(
            Image("cardDefault2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "background\(recipe.label)", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .matchedGeometryEffect(id: "mask\(recipe.label)", in: namespace)
              )
        .frame(height: 300)
    }
}

struct RecipeItem_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        RecipeItem(show: .constant(true), namespace: namespace)
    }
}
