//
//  OTPVerificationTF.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

struct OTPVerificationTF: View {
    @Binding var otpText: String
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<6, id: \.self) { index in
                OTPTextBox(index)
            }
        }
        .background {
            TextField("", text: $otpText.limit(6))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShowing)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardShowing.toggle()
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isKeyboardShowing.toggle()
                }
                .hSpacing(.trailing)
            }
        }
    }
}

extension OTPVerificationTF {
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? Color.primary : Color.gray, lineWidth: status ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.2), value: isKeyboardShowing)
        }
        .hSpacing()
    }
}

// MARK: Binding <String> Extension


struct OTPVerificationTF_Previews: PreviewProvider {
    @State static var otpText: String = ""
    static var previews: some View {
        OTPVerificationTF(otpText: $otpText)
    }
}

