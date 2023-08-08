//
//  LoadingView.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 06/08/23.
//

import SwiftUI
import Combine

struct LoadingView: View {
    let timer: Timer.TimerPublisher = Timer.publish(every: 1.2, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    @State var leftOffset: CGFloat = -100
    @State var rightOffset: CGFloat = 100
    @State var hasLoadingText = true
    
    var body: some View {
        GeometryReader { geo in
            if hasLoadingText {
                Text("Loading...")
                    .font(.title)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .fontWeight(.heavy)
                    .foregroundColor(.teal)
            }
            ZStack {
                Circle()
                    .fill(Color.teal)
                    .frame(width: 20, height: 20)
                    .offset(x: leftOffset)
                    .opacity(0.7)
                    .animation(.easeInOut(duration: 1), value: leftOffset)
                Circle()
                    .fill(Color.pink)
                    .frame(width: 20, height: 20)
                    .offset(x: leftOffset)
                    .opacity(0.7)
                    .animation(.easeInOut(duration: 1).delay(0.2), value: leftOffset)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .offset(x: leftOffset)
                    .opacity(0.7)
                    .animation(.easeInOut(duration: 1).delay(0.4), value: leftOffset)
            }
            .onAppear {
                self.connectedTimer = timer.connect()
            }
            .onDisappear {
                self.connectedTimer?.cancel()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onReceive(timer) { (_) in
                swap(&self.leftOffset, &self.rightOffset)
            }
        }
        .frame(height: 300)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

