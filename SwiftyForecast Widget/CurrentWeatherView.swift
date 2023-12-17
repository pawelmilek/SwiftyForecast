//
//  CurrentWeatherView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct CurrentWeatherView: View {
    var entry: WeatherProvider.Entry

    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .top, spacing: 0) {
                iconView
                    .frame(maxWidth: proxy.size.width * 0.5)
                locationView
                    .frame(maxWidth: proxy.size.width * 0.5, alignment: .leading)
            }
            temperatureView
            .frame(maxWidth: proxy.size.width, alignment: .center)
            .offset(y: 30)
        }
        .overlay(alignment: .bottom) {
            descriptionView
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

private extension CurrentWeatherView {
    var iconView: some View {
        entry.icon
            .resizable()
            .scaledToFit()
            .shadow(
                color: .white,
                radius: 0.5,
                x: 1,
                y: 1
            )
    }

    var locationView: some View {
        Text(entry.locationName)
            .font(.caption2)
            .fontWeight(.semibold)
            .fontDesign(.monospaced)
            .foregroundStyle(.white)
            .modifier(TextScaledModifier())
    }

    var temperatureView: some View {
        VStack(spacing: -10) {
            Text(entry.temperature)
                .font(.system(size: 50, weight: .bold, design: .monospaced))
                .modifier(TextScaledModifier())
            Text(entry.temperatureMaxMin)
                .font(.caption2)
        }
        .lineLimit(1)
        .foregroundStyle(.accent)
        .fontDesign(.monospaced)
    }

    var descriptionView: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(entry.description)
                .font(.caption2)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
                .foregroundStyle(.accent)
                .lineLimit(2)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
        }
        .background(
            Color.white
                .opacity(0.4)
                .clipShape(RoundedRectangle(cornerRadius: 9))
        )
    }
}
