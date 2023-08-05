//
//  PreferenceKeys.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
