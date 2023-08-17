//
//  GradientButton.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case success
}

struct GradientButton<ButtonContent: View>: View {
    var content: () -> ButtonContent
    var onPress: () async -> TaskStatus
    
    // properties
    @State private var taskStatus: TaskStatus = .idle
    @State private var isLoading: Bool = false
    @State private var isFailed: Bool = false
    @State private var wiggle: Bool = false
    // error popup
    @State private var showPopup: Bool = false
    @State private var popupText: String = ""
    
    var body: some View {
        Button(
            action: {
                Task {
                    isLoading = true
                    let taskStatus = await onPress()
                    switch taskStatus {
                        case .idle:
                            isFailed = false
                        case .failed(let string):
                            isFailed = true
                            popupText = string
                        case .success:
                            isFailed = false
                    }
                    
                    self.taskStatus = taskStatus
                    if isFailed {
                        try? await Task.sleep(for: .seconds(0))
                        wiggle.toggle()
                        showPopup = true
                    }
                    try? await Task.sleep(for: .seconds(0.8))
                    self.taskStatus = .idle
                    isLoading = false
                }
            },
            label: {
                content()
                    .padding(.vertical, 12)
                    .padding(.horizontal, 35)
                    .opacity(isLoading ? 0 : 1)
                    .lineLimit(1)
                    .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
                    .background(taskStatus == .idle
                                ? .linearGradient(colors: [.yellow, .orange, .red], startPoint: .top, endPoint: .bottom)
                                : taskStatus == .success
                                    ? .linearGradient(colors: [.green], startPoint: .top, endPoint: .bottom)
                                    : .linearGradient(colors: [.red], startPoint: .top, endPoint: .bottom),
                                in: .capsule)
                    .overlay {
                        if isLoading && taskStatus == .idle {
                            ProgressView()
                                .foregroundColor(.white)
                        }
                    }
                    .overlay {
                        if taskStatus != .idle {
                            Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                        }
                    }
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .wiggle(wiggle)
            }
        )
        .disabled(isLoading)
        .popover(isPresented: $showPopup, attachmentAnchor: .point(.topLeading), arrowEdge: .leading) {
            Text(popupText)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
        }
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: taskStatus)
    }
}

