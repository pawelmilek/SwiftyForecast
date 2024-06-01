//
//  AnimationView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import Vortex

struct AnimationView: View {
    let condition: WeatherCondition

    var body: some View {
        conditionView
            .background(.customPrimary)
    }

    @ViewBuilder
    private var conditionView: some View {
        switch condition {
        case .thunderstorm:
            thunderstormView
        case .drizzle:
            drizzleView
        case .rain:
            rainView
        case .snow:
            snowView
        case .atmosphere:
            atmosphereView
        case .clear:
            clearView
        case .clouds:
            cloudView
        }
    }

    private var rainView: some View {
        VortexView(condition.vortexSystem) {
            Image(systemName: "drop.fill")
                .foregroundStyle(.white)
                .font(.largeTitle)
                .frame(width: 25)
                .rotationEffect(.degrees(45))
                .tag("drop")
        }
    }

    private var drizzleView: some View {
        VortexView(condition.vortexSystem) {
            Image(systemName: "drop.fill")
                .foregroundStyle(.white)
                .font(.largeTitle)
                .frame(width: 25)
                .rotationEffect(.degrees(45))
                .tag("drop")
        }
    }

    private var snowView: some View {
        VortexView(condition.vortexSystem) {
            Image(systemName: "snowflake")
                .foregroundStyle(.white)
                .font(.largeTitle)
                .fontWeight(.bold)
                .blur(radius: 2)
                .frame(width: 25)
                .tag("snow")
        }
    }

    private var cloudView: some View {
        VortexView(condition.vortexSystem) {
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .blur(radius: 4)
                .frame(width: 50, height: 50)
                .tag("clouds")
        }
    }

    private var atmosphereView: some View {
        VortexView(condition.vortexSystem) {
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .blur(radius: 4)
                .frame(width: 50, height: 50)
                .tag("atmosphere")
        }
    }

    private var clearView: some View {
        VortexView(condition.vortexSystem) {
            Circle()
                .fill(.white)
                .blur(radius: 3)
                .frame(width: 30, height: 30)
                .tag("clear")
        }
    }

    private var thunderstormView: some View {
        ZStack {
            VortexView(condition.vortexSystem) {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .blur(radius: 2)
                    .frame(width: 50, height: 50)
                    .tag("thunderstorm")
            }

            VortexView(.darkClouds) {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .blur(radius: 4)
                    .frame(width: 50, height: 50)
                    .tag("clouds")
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        AnimationView(condition: .clear)
        Spacer()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AnimationView(condition: .clear)
        .frame(height: 300)
}