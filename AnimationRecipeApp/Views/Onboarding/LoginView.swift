//
//  LoginView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(UserObserver.self) var userModel: UserObserver
    @Binding var showSignup: Bool
    @State private var email: String = ""
    @State private var pass: String = ""
    @State private var showForgotPassword: Bool = false
    @State private var showResetView: Bool = false
    
    // OTP
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to access the Recipes")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -8)
            
            VStack(spacing: 25) {
                // textfields
                InputTF(iconName: "at", hint: "Email...", value: $email)
                InputTF(iconName: "lock", hint: "Password...", isPassword: true, value: $pass)
                    .padding(.top, 5)
                
                // forgotPassword
                Button("Forgot Password?") {
                    showForgotPassword.toggle()
                }
                .font(.callout)
                .fontWeight(.heavy)
                .tint(.yellow)
                .hSpacing(.trailing)
                
                // LoginButton
                GradientButton(content: {
                    HStack(spacing: 25) {
                        Text("Login")
                        Image(systemName: "arrow.right")
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                }, onPress: {
                    try? await Task.sleep(for: .seconds(2))
                    askOTP.toggle()
                    return .success
                })
                .hSpacing(.trailing)
//                .disableWithOpacity(email.isEmpty || pass.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            HStack(spacing: 6) {
                Text("Don't have an account?")
                    .foregroundStyle(.gray)
                
                Button("SignUp") {
                    showSignup.toggle()
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
        // Forgot Password
        .sheet(isPresented: $showForgotPassword, content: {
            if #available(iOS 16.4, *) {
                ForgotPasswordView(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPasswordView(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        // Reset Password
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *) {
                PasswordResetView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView()
                    .presentationDetents([.height(350)])
            }
        })
        // OTP Verification
        .sheet(isPresented: $askOTP, content: {
            if #available(iOS 16.4, *) {
                OTPConfirmationView(otpText: $otpText, onLogin: {
                    userModel.login(email: email)
                })
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                OTPConfirmationView(otpText: $otpText, onLogin: {
                    userModel.login(email: email)
                })
                    .presentationDetents([.height(350)])
            }
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var signUp: Bool = false
    static var previews: some View {
        LoginView(showSignup: $signUp)
            .environment(UserObserver())
    }
}

