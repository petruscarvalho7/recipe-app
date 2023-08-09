//
//  GradientButton.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var iconName: String
    var onPress: () -> ()
    
    var body: some View {
        Button(action: onPress, label: {
            HStack(spacing: 25) {
                Text(title)
                Image(systemName: iconName)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(.linearGradient(colors: [.yellow, .orange, .red], startPoint: .top, endPoint: .bottom), in: .capsule)
        })
    }
}

//struct GradientButton_Previews: PreviewProvider {
//    static var previews: some View {
//        GradientButton()
//    }
//}

