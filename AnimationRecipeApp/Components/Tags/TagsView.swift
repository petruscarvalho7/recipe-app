//
//  TagsView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 16/08/23.
//

import SwiftUI

struct TagsView: View {
    @State private var tags: [String] = ["Pasta", "Meat", "Chicken", "Pork", "Cheese", "Chocolate", "Fish", "Onion", "Garlic", "Tomato", "Potato", "Carrot", "Bread", "Butter", "Heavycream", "Ginger"]
    
    @Binding var showTags: Bool
    
    var onSubmit: (_ text: String) -> ()

    // selected tags
    @State var preSelectedTags: [String] = []
    @Binding var selectedTags: [String]
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Button {
                    withAnimation {
                        showTags = false
                        selectedTags = preSelectedTags
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }

            }
            .hSpacing(.leading)
            .padding(20)
            .padding(.bottom, 10)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(preSelectedTags, id: \.self) { tag in
                        TagView(tag: tag, color: .pink, icon: "checkmark")
                            .matchedGeometryEffect(id: tag, in: namespace)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    preSelectedTags.removeAll {
                                        $0 == tag
                                    }
                                }
                            }
                    }
                }
                .padding(.horizontal, 15)
                .frame(height: 35)
                .padding(.bottom, 15)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .overlay {
                if preSelectedTags.isEmpty {
                    Text("Select Tags")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            .backgroundStyle(.white)
            
            ScrollView(.vertical) {
                TagLayout(alignment: .center) {
                    ForEach(tags.filter { !preSelectedTags.contains($0) },
                            id: \.self) { tag in
                        TagView(tag: tag, color: .blue, icon: "plus")
                            .matchedGeometryEffect(id: tag, in: namespace)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    preSelectedTags.insert(tag, at: 0)
                                }
                            }
                    }
                }
                .padding(15)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .background(.black.opacity(0.05))
            
            ZStack {
                Button {
                    withAnimation {
                        showTags = false
                        selectedTags = preSelectedTags
                        if (selectedTags.count > 0) {
                            let searchText = selectedTags.joined(separator: ", ")
                            onSubmit(searchText)
                        }
                    }
                } label: {
                    Text("Search")
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.pink.gradient)
                        }
                }
                .padding()
                .disabled(preSelectedTags.count < 1)
                .opacity(preSelectedTags.count < 1 ? 0.5 : 1)

            }
            .background(.white)
        }
        .preferredColorScheme(.light)
        .onAppear {
            if !$selectedTags.isEmpty {
                preSelectedTags.append(contentsOf: selectedTags)
            }
        }
    }
}

#Preview {
    TagsView(showTags: .constant(true), onSubmit: {text in print(text) }, selectedTags: .constant(["Pasta"]))
}
