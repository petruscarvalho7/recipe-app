//
//  NavigationBar.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var hasScrolled: Bool
    @State var showSearch = false
    @State private var searchText: String = ""
    
    var onSubmit: (_ text: String) -> ()
    var title = ""
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .blur(radius: 10)
                .opacity(hasScrolled ? 1 : 0)
            
            if !showSearch {
                Text(title)
                    .animatableFont(size: hasScrolled ? 22 : 34, weight: .bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    .offset(y: hasScrolled ? 4 : 0)
            }
            
            Spacer(minLength: 0)
            
            HStack {
                if showSearch {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: 45, height: 45)
                        .foregroundColor(.gray)
                    
                    TextField("",
                              text: $searchText,
                              prompt: Text("Search recipes...")
                        .foregroundColor(.gray)
                    )
                    .onSubmit {
                        guard searchText.count > 3 else { return }
                        onSubmit(searchText)
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSearch.toggle()
                            searchText = ""
                        }
                    }
                    .foregroundColor(.gray)
                    .foregroundStyle(.gray)
                    
                    Button {
                        searchText = ""
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSearch.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                } else {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSearch.toggle()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 17, weight: .bold))
                            .frame(width: 45, height: 45)
                            .foregroundColor(.gray)
                            .background(.ultraThinMaterial, in:
                                            RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .strokeStyle(cornerRadius: 14)
                    }
                    .clipShape(Circle())
                }
                
            }
            .background(hasScrolled ? .white : .orange.opacity(0.5))
            .cornerRadius(30)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 20)
            .offset(y: hasScrolled ? 4 : 0)
        }
        .zIndex(0)
        .frame(height: hasScrolled ? 44 : 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(hasScrolled: .constant(false), onSubmit: { text in
            print(text)
        }, title: "Featured")
    }
}
