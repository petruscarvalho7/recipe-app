//
//  ContentView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: ModelObserver
    @AppStorage("selTab") var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
                switch selectedTab {
                case .home:
                    HomeView()
                case .favorites:
                    HomeView(isFavorite: true, title: "Favorites")
                case .profile:
                    ProfileView()
                }
            
            TabBar()
                .offset(y: model.showDetail ? 200 : 0)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 44)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(ModelObserver())
    }
}
