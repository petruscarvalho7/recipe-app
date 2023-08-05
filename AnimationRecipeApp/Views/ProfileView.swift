//
//  ProfileView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Profile")
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
