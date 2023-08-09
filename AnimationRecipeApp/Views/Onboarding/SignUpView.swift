//
//  SignUpView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct SignUpView: View {
    @Binding var showSignup: Bool
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var pass: String = ""
    
    // OTP
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                showSignup = false
            } label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 10)

            
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please sign up to access the Recipes")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -8)
            
            VStack(spacing: 25) {
                // textfields
                InputTF(iconName: "person", hint: "Username...", value: $username)
                InputTF(iconName: "at", hint: "Email...", value: $email)
                InputTF(iconName: "lock", hint: "Password...", isPassword: true, value: $pass)
                    .padding(.top, 5)
                
                // LoginButton
                GradientButton(title: "Sign Up", iconName: "arrow.right") {
                    askOTP.toggle()
                }
                .hSpacing(.trailing)
                .disableWithOpacity(email.isEmpty || pass.isEmpty || username.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            HStack(spacing: 6) {
                Text("Already have an account?")
                    .foregroundStyle(.gray)
                
                Button("Login") {
                    showSignup = false
                }
                .fontWeight(.bold)
                .tint(.yellow)
            }
            .font(.callout)
            .hSpacing()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
        // OTP Verification
        .sheet(isPresented: $askOTP, content: {
            if #available(iOS 16.4, *) {
                OTPConfirmationView(otpText: $otpText)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                OTPConfirmationView(otpText: $otpText)
                    .presentationDetents([.height(350)])
            }
        })
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var signUp: Bool = false
    static var previews: some View {
        SignUpView(showSignup: $signUp)
    }
}

