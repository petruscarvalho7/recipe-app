//
//  InputTF.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct InputTF: View {
    var iconName: String
    var iconTint: Color = .gray
    var hint: String
    var isPassword: Bool = false
    @Binding var value: String
    @State private var showPassword: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: iconName)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                if isPassword {
                    if !showPassword {
                        SecureField(hint, text: $value)
                    } else {
                        TextField(hint, text: $value)
                    }
                } else {
                    TextField(hint, text: $value)
                }
                
                Divider()
            }
            .overlay(alignment: .trailing) {
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            }
        }
    }
}

