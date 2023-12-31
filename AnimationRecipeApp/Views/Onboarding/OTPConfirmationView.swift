//
//  OTPConfirmationView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct OTPConfirmationView: View {
    @Environment(ModelObserver.self) var model: ModelObserver
    @Environment(\.dismiss) private var dismiss
    
    @Binding var otpText: String
    var onLogin: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                guard let toLogin = onLogin else { return }
                toLogin()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 10)
            
            Text("Enter Code")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)

            Text("An 6 digit code has been sent to your Email.")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -8)
            
            VStack(spacing: 25) {
                // OTP Verification
                OTPVerificationTF(otpText: $otpText)
                
                // LoginButton
                GradientButton(content: {
                    HStack(spacing: 25) {
                        Text("Confirm")
                        Image(systemName: "arrow.right")
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                }, onPress: {
                    withAnimation(.linear(duration: 1.5)) {
                        dismiss()
                        model.loggedInOut = .loggedIn
                        return .success
                    }
                })
                .hSpacing(.trailing)
                .disableWithOpacity(otpText.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
    }
}

struct OTPConfirmationView_Previews: PreviewProvider {
    @State static var otpText: String = ""
    static var previews: some View {
        OTPConfirmationView(otpText: $otpText)
    }
}
