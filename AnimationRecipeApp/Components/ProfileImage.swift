//
//  ProfileImage.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 12/08/23.
//

import SwiftUI

struct ProfileImage: View {
    var profileImage: String
    @State var showImagePicker: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                showImagePicker.toggle()
            }
        }, label: {
            Image(profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .foregroundColor(.gray)
                .background(Color.primary)
                .clipShape(Circle())
                .shadow(color: .blue, radius: 20, x: 0.0, y: 0.0)
        })
        .actionSheet(isPresented: $showImagePicker, content: {
            SheetImageSheet
        })
    }
}

extension ProfileImage {
    var SheetImageSheet: ActionSheet {
        ActionSheet(
            title: Text("Do you want to change your profile picture?"),
            message: Text("Choose the option"),
            buttons: [
                .default(Text("Take Picture"), action: {}),
                .default(Text("Gallery"), action: {}),
                .destructive(Text("Cancel"), action: {
                    withAnimation {
                        showImagePicker = false
                    }
                })
            ]
        )
    }
}

#Preview {
    ProfileImage(profileImage: "defaultProfile")
}
