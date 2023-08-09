//
//  ForgotPasswordView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showResetView: Bool
    @State private var email: String = ""
    
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
            
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please enter your Email, and then we can send the reset password link")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -8)
            
            VStack(spacing: 25) {
                // textfields
                InputTF(iconName: "at", hint: "Email...", value: $email)
                
                // LoginButton
                GradientButton(title: "Continue", iconName: "arrow.right") {
                    Task {
                        dismiss()
                        try? await Task.sleep(for: .seconds(0))
                        showResetView = true
                    }
                }
                .hSpacing(.trailing)
                .disableWithOpacity(email.isEmpty)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    @State static var showResetView: Bool = false

    static var previews: some View {
        ForgotPasswordView(showResetView: $showResetView)
    }
}
