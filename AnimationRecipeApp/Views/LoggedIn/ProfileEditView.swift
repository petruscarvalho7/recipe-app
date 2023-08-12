//
//  ProfileEditView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 12/08/23.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showChangePasswordView: Bool = false
    @State var fullname: String = ""
    @State var email: String = ""
    
    var user: User

    var body: some View {
        ZStack {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 40) {
                ProfileImage(profileImage: user.profileImage)
                    .padding(.top, 80)
                
                VStack(spacing: 20) {
                    InputTF(iconName: "person", hint: "Fullname...", value: $fullname)
                        .onAppear {
                            fullname = user.fullname
                        }
                    InputTF(iconName: "at", hint: "Email...", value: $email)
                        .onAppear {
                            email = user.email
                        }
                    // forgotPassword
                    Button("Change Password?") {
                        showChangePasswordView.toggle()
                    }
                    .font(.callout)
                    .fontWeight(.heavy)
                    .tint(.yellow)
                    .hSpacing(.trailing)
                    
                    Spacer()
                    GradientButton(title: "Save", iconName: "checkmark") {
                        /// TODO: save
                    }
                    .hSpacing(.center)
                    .disableWithOpacity(email.isEmpty || fullname.isEmpty)
                    Spacer()
                }
                .padding(20)
                .edgesIgnoringSafeArea(.bottom)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                )
            }
        }
        // Reset Password
        .sheet(isPresented: $showChangePasswordView, content: {
            if #available(iOS 16.4, *) {
                PasswordResetView(titleButtonText: "Change Password")
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView(titleButtonText: "Change Password")
                    .presentationDetents([.height(350)])
            }
        })
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}

extension ProfileEditView {
    var backButton : some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.left.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
    }
}

#Preview {
    ProfileEditView(user: User.MOCK_USER)
}
