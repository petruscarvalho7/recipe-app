//
//  TabBar.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//

import SwiftUI

struct TabBar: View {
    @AppStorage("selTab") var selectedTab: Tab = .home
    @State var color: Color = .teal
    @State var tabItemWidth: CGFloat = .zero
    
    var body: some View {
        GeometryReader { proxy in
            let hasHomeIndicator  = proxy.safeAreaInsets.bottom > 20
            
            HStack {
                buttons
            }
            .padding(.horizontal, 8)
            .padding(.top, 14)
            .frame(height: hasHomeIndicator ? 70 : 52, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: hasHomeIndicator ? 34 : 0, style: .continuous))
            .background(
                selectedTabBackgroundColor()
            )
            .overlay(
                selectedTabOverlayColor()
            )
            .strokeStyle(cornerRadius: hasHomeIndicator ? 34 : 0)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 40)
        .ignoresSafeArea()
        }
        .padding(.horizontal, 15)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

extension TabBar {
    func selectedTabBackgroundColor() -> some View {
        HStack {
            if selectedTab == .profile { Spacer() }
            if selectedTab == .favorites { Spacer() }
            Circle().fill(color).frame(width: tabItemWidth)
            if selectedTab == .home { Spacer() }
            if selectedTab == .favorites { Spacer() }
        }
        .padding(.horizontal, 8)
    }
    
    func selectedTabOverlayColor() -> some View {
        HStack {
            if selectedTab == .profile { Spacer() }
            if selectedTab == .favorites { Spacer() }
            Rectangle()
                .fill(color)
                .cornerRadius(3)
                .frame(width: 28, height: 5)
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
            if selectedTab == .home { Spacer() }
            if selectedTab == .favorites { Spacer() }
        }
        .padding(.horizontal, 8)
    }
    
    var buttons: some View {
        ForEach(tabItems) { item in
            Button {
                withAnimation(.spring(
                    response: 0.3,
                    dampingFraction: 0.7)) {
                    selectedTab = item.selection
                    color       = item.color
                }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: item.icon)
                        .symbolVariant(.fill)
                        .font(.body.bold())
                        .frame(width: 44, height: 29)
                    Text(item.name)
                        .font(.caption2)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(selectedTab == item.selection ? .primary : .secondary)
            .blendMode(selectedTab == item.selection ? .overlay : .normal)
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
                }
            )
            .onPreferenceChange(TabPreferenceKey.self) { value in
                tabItemWidth = value
            }
        }
    }
}
