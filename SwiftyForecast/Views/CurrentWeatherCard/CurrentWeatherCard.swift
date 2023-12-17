//
//  CurrentWeatherCard.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct CurrentWeatherCard: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 15) {
                locationNameView
                HStack(spacing: 0) {
                    iconDescriptionView
                        .frame(maxWidth: proxy.size.width * 0.5)
                    temperatureView
                        .frame(maxWidth: proxy.size.width * 0.5)
                }
                conditionsView
            }
            .foregroundStyle(Style.WeatherCard.textColor)
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: Style.WeatherCard.cornerRadius)
                    .inset(by: 2.5)
                    .fill(Style.WeatherCard.backgroundColor)
                    .strokeBorder(
                        .shadow,
                        lineWidth: Style.WeatherCard.lineBorderWidth,
                        antialiased: true
                    )
            )
            .compositingGroup()
            .shadow(
                color: Style.WeatherCard.shadowColor,
                radius: Style.WeatherCard.shadowRadius,
                x: Style.WeatherCard.shadow.x,
                y: Style.WeatherCard.shadow.y
            )
        }
        .frame(maxHeight: 250)
    }
}

private extension CurrentWeatherCard {

    var locationNameView: some View {
        Text(viewModel.locationName)
            .font(Style.WeatherCard.locationNameFont)
            .id(viewModel.locationName)
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
    }

    var iconDescriptionView: some View {
        VStack(spacing: 0) {
            iconView
            dayDescriptionView
        }
        .id(viewModel.description)
        .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
    }

    var iconView: some View {
        Group {
            if let icon = viewModel.icon {
                icon
            } else {
                Image(.defaultConditionContent)
            }
        }
        .shadow(
            color: Style.WeatherCard.iconShadowColor,
            radius: Style.WeatherCard.iconShadowRadius,
            x: Style.WeatherCard.iconShadowOffset.width,
            y: Style.WeatherCard.iconShadowOffset.height
        )
    }

    var dayDescriptionView: some View {
        VStack {
            Text(viewModel.daytimeDescription)
            Text(viewModel.description)
                .modifier(TextScaledModifier())
        }
        .font(Style.WeatherCard.dayDescriptionFont)
    }

    var temperatureView: some View {
        VStack(spacing: 0) {
            Text(viewModel.temperature)
                .font(Style.WeatherCard.temperatureFont)
                .modifier(TextScaledModifier())
            VStack {
                Text("")
                Text(viewModel.temperatureMaxMin)
            }
            .font(Style.WeatherCard.temperatureMaxMinFont)
        }
        .id(viewModel.temperature)
        .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
    }

    var conditionsView: some View {
        HStack(spacing: 15) {
            VStack {
                Image(systemName: viewModel.sunrise.symbol)
                Text(viewModel.sunrise.getTime())
            }
            .id(viewModel.sunrise.getTime())
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))

            VStack {
                Image(systemName: viewModel.windSpeed.symbol)
                Text(viewModel.windSpeed.value)
            }
            .id(viewModel.windSpeed.value)
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))

            VStack {
                Image(systemName: viewModel.humidity.symbol)
                Text(viewModel.humidity.value)
            }
            .id(viewModel.humidity.value)
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))

            VStack {
                Image(systemName: viewModel.sunset.symbol)
                Text(viewModel.sunset.getTime())
            }
            .id(viewModel.sunset.getTime())
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
        }
        .font(Style.WeatherCard.conditionsFont)
        .fixedSize()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CurrentWeatherCard(viewModel: CurrentWeatherCard.ViewModel())
        .padding(22.5)
}
