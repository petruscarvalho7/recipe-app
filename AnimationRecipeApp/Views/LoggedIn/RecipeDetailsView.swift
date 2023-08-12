//
//  RecipeDetailsView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

struct RecipeDetailsView: View {
    @Environment(ModelObserver.self) var model: ModelObserver
    @Binding var show: Bool
    @State var viewState: CGSize = .zero
    @State var showContent = true
    @State var isDraggble = true
    @State var isFavorite = false
    @State var appear = [false, false, false]
    @State var favRecipeData: FavoriteRecipes?
    var delegate: RecipeDelegate
    var recipe: Recipe = recipesMock[0]
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
                
            }
            .coordinateSpace(name: "scroll")
            .onAppear { model.showDetail = true }
            .onDisappear { model.showDetail = false }
            .background(Color("Background"))
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(viewState.width / -500 + 1)
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture(isDraggble ? drag : nil)
            .ignoresSafeArea()
               
           button
        }
        .onAppear {
            fadeIn()
        }
        .onChange(of: show) {
            fadeOut()
        }
    }
}

// subviews
extension RecipeDetailsView {
    var button: some View {
        Button {
            showContent.toggle()
            withAnimation(.closeCard) {
                show.toggle()
                model.showDetail.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.weight(.bold))
                .foregroundColor(.white)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(30)
        .ignoresSafeArea()
    }

    var cover: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY
            
            VStack(alignment: .leading, spacing: 12) {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 550 + scrollY : 550)
            .foregroundStyle(.black)
            .background(
                AsyncImage(
                    url: recipe.getImageThumbnail(),
                    content: { image in
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(.bottom, 230)
                            .matchedGeometryEffect(id: "image\(recipe.label)", in: namespace)
                            .offset(y: scrollY > 0 ? scrollY * -0.8 : 0)
                    },
                    placeholder: {
                        Image("recipePlaceholder")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(.bottom, 230)
                            .matchedGeometryEffect(id: "image\(recipe.label)", in: namespace)
                            .offset(y: scrollY > 0 ? scrollY * -0.8 : 0)
                    }
                )
            )
            .background(
                Image("cardDefault2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: "background\(recipe.label)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0 ? scrollY / 1000 + 1 : 1)
                    .blur(radius: scrollY / 10)
            )
            .mask(
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30, style: .continuous)
                    .matchedGeometryEffect(id: "mask\(recipe.label)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
            .overlay(
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.getHealthLabels())
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .matchedGeometryEffect(id: "ingredients", in: namespace)
                    Text(recipe.getServingsWithKcal().uppercased())
                        .font(.footnote.weight(.semibold))
                        .matchedGeometryEffect(id: "subtitle", in: namespace)
                    Text(recipe.label)
                        .font(.largeTitle.weight(.bold))
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                    Divider()
                        .opacity(appear[0] ? 1 : 0)
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("•")
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                                Text("Protein".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Text(recipe.getProtein())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            HStack {
                                Text("•")
                                    .font(.largeTitle)
                                    .foregroundColor(.yellow)
                                    .fontWeight(.bold)
                                Text("FAT".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Text(recipe.getFat())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            HStack {
                                Text("•")
                                    .font(.largeTitle)
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                                Text("Carb".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Text(recipe.getCarbs())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                        }
                        Divider()
                            .frame(minWidth: 10)
                            .foregroundColor(.black)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Cholesterol".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(recipe.getCholes())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            HStack {
                                Text("Sodium".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(recipe.getSodium())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            HStack {
                                Text("Calcium".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(recipe.getCalcium())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            HStack {
                                Text("Magnesium".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(recipe.getMag())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            HStack {
                                Text("Potassium".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(recipe.getPot())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            HStack {
                                Text("Iron".uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(recipe.getIron())
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .opacity(appear[1] ? 1 : 0)
                    Divider()
                        .opacity(appear[0] ? 1 : 0)
                    HStack {
                        Image(systemName: "heart")
                            .symbolVariant(isFavorite ? .fill : .none)
                            .font(.body.bold())
                            .frame(width: 44,height: 29)
                            .foregroundColor(isFavorite ? .red : .none)
                        Text(!isFavorite ? "Favorite" : "Unfavorite")
                            .font(.footnote)
                    }
                    .opacity(appear[1] ? 1 : 0)
                    .onTapGesture {
                        withAnimation(.spring) {
                            if isFavorite {
                                delegate.removeFavRecipe(favRecipeData: favRecipeData)
                                close()
                            } else {
                                delegate.saveFavRecipe(recipe: recipe)
                            }
                            isFavorite = !isFavorite
                        }
                    }
                }
                    .padding(20)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .matchedGeometryEffect(id: "blur", in: namespace)
                    )
                    .offset(y: 250)
                    .padding(20)
            )
        }
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                guard value.translation.width > 0 else { return }
                
                if value.startLocation.x < 100 {
                    withAnimation {
                        viewState = value.translation
                    }
                }
                
                if viewState.width > 250 {
                    close()
                }
            }
            .onEnded { value in
                if viewState.width > 180 {
                    close()
                } else {
                    withAnimation(.openCard) {
                        viewState = .zero
                    }
                }
            }
    }
    
    func fadeIn() {
        withAnimation(.easeInOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeInOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeInOut.delay(0.5)) {
            appear[2] = true
        }
    }
    
    func fadeOut() {
        appear[0] = false
        appear[1] = false
        appear[2] = false
    }
    
    func close() {
        showContent = false
        withAnimation {
            viewState = .zero
        }
        withAnimation(.closeCard.delay(0.2)) {
            model.showDetail = false
            model.selectedCourse = 0
            show = false
        }
        isDraggble = false
    }
}

struct RecipeDetailsView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        RecipeDetailsView(show: .constant(true), delegate: HomeView(), namespace: namespace)
            .environment(ModelObserver())
    }
}

