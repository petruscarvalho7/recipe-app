//
//  View+Extension\.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 09/08/23.
//

import SwiftUI

fileprivate struct ParticleModifier: ViewModifier {
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color
    // properties
    @State private var particles: [Particle] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(particles) { particle in
                        Image(systemName: systemImage)
                            .foregroundColor(status ? activeTint : inActiveTint)
                            .frame(width: 44, height: 29)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            /// only visible when status is active
                            .opacity(status ? 1 : 0)
                            /// making base visibility with zero animation
                            .animation(.none, value: status)
                    }
                }
                .onAppear {
                    if particles.isEmpty {
                        for _ in 0...15 {
                            let particle = Particle()
                            particles.append(particle)
                        }
                    }
                }
                .onChange(of: status) { _, newValue in
                    if !newValue {
                        // reset animation
                        for index in particles.indices {
                            particles[index].reset()
                        }
                    } else {
                        for index in particles.indices {
                            // randoms
                            let total: CGFloat = CGFloat(particles.count)
                            let progress: CGFloat = CGFloat(index) / total
                            
                            let maxX: CGFloat = (progress > 0.5) ? 100 : -100
                            let maxY: CGFloat = 60
                            
                            let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
                            let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY)
                            let randomScale: CGFloat = .random(in: 0.35...1)
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                                let extraRandomY: CGFloat = .random(in: 0...30)
                                
                                particles[index].randomX = randomX + extraRandomX
                                particles[index].randomY = -randomY - extraRandomY
                            }
                            
                            // scaling with ease animation
                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[index].scale = randomScale
                            }
                            
                            // removing particles based on index
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)
                                .delay(0.25 + (Double(index) * 0.005))) {
                                    particles[index].scale = 0.001
                                }
                            
                        }
                    }
                }
            }
    }
    
}

extension View {
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: alignment)
    }
    
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition).opacity(condition ? 0.5 : 1)
    }
    
    @ViewBuilder
    func particleEffect(systemImage: String, font: Font, status: Bool, activeTint: Color, inActiveTint: Color) -> some View {
        self.modifier(
            ParticleModifier(systemImage: systemImage, font: font, status: status, activeTint: activeTint, inActiveTint: inActiveTint)
        )
    }
    
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self.keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view.offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
    }
}
