//
//  PasswordResetView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct PasswordResetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var titleButtonText: String = "Reset Password"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 10)
            
            Text(titleButtonText)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            VStack(spacing: 25) {
                // textfields
                InputTF(iconName: "lock", hint: "Password...", isPassword: true, value: $password)
                InputTF(iconName: "lock", hint: "Confirm password...", isPassword: true, value: $confirmPassword)
                
                // LoginButton
                GradientButton(title: titleButtonText, iconName: "arrow.right") {
          
                }
                .hSpacing(.trailing)
                .disableWithOpacity(password.isEmpty || confirmPassword.isEmpty)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}

