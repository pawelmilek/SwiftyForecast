//
//  MotionAnimationView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI

struct MotionAnimationView: View {
    @State private var randomCircle = Int.random(in: 8...16)
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0...randomCircle, id: \.self) { _ in
                    Circle()
                        .foregroundStyle(.white)
                        .opacity(0.10)
                        .frame(
                            maxWidth: randomLenght(max: proxy.size.height),
                            maxHeight: randomLenght(max: proxy.size.height)
                        )
                        .scaleEffect(isAnimating ? randomScale() : 1)
                        .position(
                            x: randomCoordinate(max: proxy.size.width),
                            y: randomCoordinate(max: proxy.size.height)
                        )
                        .animation(
                            .interpolatingSpring(stiffness: 0.5, damping: 1)
                            .repeatForever()
                            .speed(randomSpeed())
                            .delay(randomDelay()),
                            value: isAnimating
                        )
                        .onAppear {
                            isAnimating = true
                        }
                }
            }
            .background(.customPrimary)
            .drawingGroup()
        }
    }

    private func randomLenght(max: CGFloat) -> CGFloat {
        CGFloat(Int.random(in: 10...Int(max)))
    }

    private func randomScale() -> CGFloat {
        CGFloat(Double.random(in: 0.1...2.0))
    }

    private func randomCoordinate(max: CGFloat) -> CGFloat {
        CGFloat.random(in: 0...max)
    }

    private func randomSpeed() -> Double {
        Double.random(in: 0.1...1.0)
    }

    private func randomDelay() -> Double {
        Double.random(in: 0...2.0)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MotionAnimationView()
        .frame(height: 300)
}
