//
//  ProfileEditView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 12/08/23.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}

extension ProfileEditView {
    var backButton : some View {
        Button(action: {
            print("BACKBUTTON")
            dismiss()
        }) {
            Image(systemName: "arrow.left.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.black.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
    }
}

#Preview {
    ProfileEditView()
}
