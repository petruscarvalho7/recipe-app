//
//  TagView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 16/08/23.
//

import SwiftUI

struct TagView: View {
    var tag: String
    var color: Color
    var icon: String
    
    var body: some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)
            
            Image(systemName: icon)
        }
        .frame(height: 35)
        .foregroundStyle(.white)
        .padding(.horizontal, 15)
        .background(
            Capsule()
                .fill(color.gradient)
        )
    }
}

#Preview {
    TagView(tag: "Pasta", color: .blue, icon: "plus")
}
