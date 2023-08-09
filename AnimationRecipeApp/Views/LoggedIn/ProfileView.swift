//
//  ProfileView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

private enum Field: Hashable {
    case email, name
}

struct ProfileView: View {
    @EnvironmentObject var model: ModelObserver
    @Binding var selectedTab: Tab
    // textfields
    @State var textFieldEmail = "monkeydluffy@pirate.com"
    @State var textFieldName = "Monkey D. Luffy"
    // enable textfields
    @State private var disableEmail = true
    @State private var disableName = true
    @FocusState private var focused: Field?
    
    // logout shadows animations
    @State private var shadowColor: Color = .red
    @State private var shadowRadius: CGFloat = 20
    @State private var shadowX: CGFloat = 0
    @State private var shadowY: CGFloat = 0
    
    @FocusState var isFocusOn: Bool
    
    var body: some View {
        VStack(alignment: .center,spacing: 20) {
            Button(action: {
                print("tapped!")
            }, label: {
                Image("defaultProfile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
                    .background(Color.primary)
                    .clipShape(Circle())
                    .overlay {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white.opacity(0.8))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    }
                    .shadow(color: .blue, radius: 20, x: 0.0, y: 0.0)
                    .padding(.vertical, 100)
            })
            HStack {
                Button {
                    disableEmail.toggle()
                } label: {
                    Image(systemName: "mail")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                if disableEmail {
                    TextField(
                        "Email",
                        text: $textFieldEmail
                    )
                    .foregroundColor(.accentColor)
                    .disabled(true)
                    .shadow(color: .blue, radius: 20, x: 0.0, y: 0.0)
                } else {
                    TextField(
                        "Email",
                        text: $textFieldEmail
                    )
                    .disableAutocorrection(true)
                    .foregroundColor(.accentColor)
                    .disabled(disableEmail)
                    .onChange(of: focused) {}
                    .focused($focused, equals: .email)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            focused = .email
                        }
                    }
                }
            }
            .onChange(of: disableEmail) {
                if !disableName {
                    focused = .email
                }
            }
            .frame(width: 260)
            .padding(10)
            .border(.blue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            .padding(.horizontal, 40)
            HStack(alignment: .center) {
                Button {
                    disableName.toggle()
                } label: {
                    Image(systemName: "pencil")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                if disableName {
                    TextField(
                        "Name",
                        text: $textFieldName
                    )
                    .foregroundColor(.accentColor)
                    .disabled(true)
                } else {
                    TextField(
                        "Name",
                        text: $textFieldName
                    )
                    .focused($focused, equals: .name)
                    .disableAutocorrection(true)
                    .foregroundColor(.accentColor)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            focused = .name
                        }
                    }
                }
                    
            }
            .padding(10)
            .border(.blue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            .padding(.horizontal, 40)
            Text("*to edit the fields you can click on the icons")
                .font(.footnote)
                .foregroundColor(.red)
            Spacer()
            Button(action: {
                withAnimation(.linear(duration: 1.5)) {
                    shadowColor = .yellow
                    shadowRadius = 40
                    shadowX = 0.0
                    shadowY = 0.0
                    model.loggedInOut = .onboarding
                    selectedTab = .home
                }
            }, label: {
                Text("LOGOUT")
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .tracking(2.0)
                    .frame(width: 200, height: 50)
                    .background(Color.red)
                    .cornerRadius(15)
                    .padding()
            })
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var tab: Tab = .profile
    
    static var previews: some View {
        ProfileView(selectedTab: $tab)
    }
}
