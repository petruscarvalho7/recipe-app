//
//  ContentView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelObserver.self) var model: ModelObserver
    
    //Onboarding
    @State private var showSignup: Bool = false
    // Keyboard Status
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        if model.loggedInOut == .onboarding {
            // Onboarding stack
            NavigationStack {
                LoginView(showSignup: $showSignup)
                    .navigationDestination(isPresented: $showSignup) {
                        SignUpView(showSignup: $showSignup)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                        if !showSignup {
                            isKeyboardShowing = true
                        }
                    })
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                        isKeyboardShowing = false
                    })

            }
            .overlay {
                if #available(iOS 17, *) {
                    CircleAnimatedView()
                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
                        .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
                } else {
                    CircleAnimatedView()
                        .animation(.easeInOut(duration: 0.3), value: showSignup)
                        .animation(.easeInOut(duration: 0.3), value: isKeyboardShowing)
                }
            }
        } else {
            NavigationStack {
                LoggedInView()
                    .navigationDestination(for: User.self) { user in
                        ProfileEditView(user: user)
                    }
            }
        }
    }
}

extension ContentView {
    // Onboarding Circle animation
    @ViewBuilder
    func CircleAnimatedView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.yellow, .orange, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            .offset(x: showSignup ? 90 : -90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environment(ModelObserver())
        .environment(RecipeObserver())
    }
}
