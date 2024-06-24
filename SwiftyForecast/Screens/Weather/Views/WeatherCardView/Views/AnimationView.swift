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
            cloudsView
        default:
            Color.customPrimary
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

    private var cloudsView: some View {
        VortexViewReader { proxy in
            VortexView(condition.vortexSystem) {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .blur(radius: 1.2)
                    .frame(width: 50, height: 50)
                    .tag("clouds")
            }
            .onAppear {
                proxy.burst()
            }
        }
    }

    private var atmosphereView: some View {
        VortexView(condition.vortexSystem) {
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .blur(radius: 2.5)
                .frame(width: 50, height: 50)
                .tag("atmosphere")
        }
    }

    private var clearView: some View {
        VortexViewReader { proxy in
            VortexView(condition.vortexSystem) {
                Circle()
                    .fill(.white)
                    .frame(width: 30, height: 30)
                    .tag("clear")
            }
            .onAppear {
                proxy.burst()
            }
        }
    }

    private var thunderstormView: some View {
        ZStack {
            VortexView(condition.vortexSystem) {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .blendMode(.plusLighter)
                    .tag("thunderstorm")
            }

            VortexViewReader { proxy in
                VortexView(.darkClouds) {
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .blur(radius: 1.2)
                        .frame(width: 50, height: 50)
                        .tag("clouds")
                }
                .onAppear {
                    proxy.burst()
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        AnimationView(condition: .thunderstorm)
        Spacer()
    }
}
