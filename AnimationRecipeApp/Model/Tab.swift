//
//  Tab.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var selection: Tab
}

var tabItems = [
    TabItem(name: "Home",
            icon: "house",
            color: .teal,
            selection: .home),
    TabItem(name: "Favorites",
            icon: "heart",
            color: .pink,
            selection: .favorites),
    TabItem(name: "Profile",
            icon: "person.crop.circle",
            color: .blue,
            selection: .profile)
]

enum Tab: String {
    case home
    case favorites
    case profile
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

