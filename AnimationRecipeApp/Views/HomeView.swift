//
//  HomeView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: Model
    @Namespace var namespace
    @State var showStatusBar = true
    @State var selectedIndex = 0
    @State var hasScrolled = false
    @State var showCourse = false
    @State var selectedID = UUID()
    @State var show = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                scrollDetection
                
                Text("Recipes".uppercased())
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                LazyVGrid(columns: [GridItem(
                    .adaptive(minimum: 300), spacing: 20)], spacing: 20) {
                    if !show {
                        cards
                    } else {
                        ForEach(recipesMock) { recipe in
                            Rectangle()
                                .fill(.white)
                                .frame(height: 300)
                                .cornerRadius(30)
                                .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                                .opacity(0.3)
                                .padding(.horizontal, 30)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .coordinateSpace(name: "scroll")
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 70)
            })
            .overlay(
                NavigationBar(hasScrolled: $hasScrolled, title: "Home")
            )
            
            if show {
                detail
            }
        }
        .statusBarHidden(!showStatusBar)
        .onChange(of: show) { newValue in
            withAnimation(.closeCard) {
                if newValue {
                    showStatusBar = false
                } else {
                    showStatusBar = true
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Model())
    }
}

extension HomeView {
    var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: ScrollPreferenceKey.self,
                value: proxy.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    hasScrolled = true
                } else {
                    hasScrolled = false
                }
            }
        })
    }
    
    var cards: some View {
        ForEach(recipesMock) { recipe in
            RecipeItem(show: $show, namespace: namespace, recipe: recipe)
                .onTapGesture {
                    withAnimation(.openCard) {
                        show.toggle()
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectedID = recipe.id
                }
            }
        }
    }
    
    var detail: some View {
        ForEach(recipesMock) { recipe in
            if recipe.id == selectedID {
                RecipeDetailsView(show: $show, recipe: recipe, namespace: namespace)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                        removal:   .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))))
            }
        }
    }
}
