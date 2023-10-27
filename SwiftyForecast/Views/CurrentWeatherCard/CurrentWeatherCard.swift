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
        VStack(spacing: 15) {
            locationNameView
            HStack(spacing: 25) {
                VStack {
                    iconView
                    dayDescriptionView
                }
                temperatureView
            }
            conditionsView
        }
        .foregroundStyle(Style.WeatherCard.textColor)
        .padding(15)
        .frame(maxWidth: .infinity)
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
}

private extension CurrentWeatherCard {

    var locationNameView: some View {
        Text(viewModel.locationName)
            .font(Style.WeatherCard.locationNameFont)
    }

    var iconView: some View {
        Group {
            if let icon = viewModel.icon {
                Image(uiImage: icon)
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
        }
        .font(Style.WeatherCard.dayDescriptionFont)
    }

    var temperatureView: some View {
        VStack {
            Text(viewModel.temperature)
                .font(Style.WeatherCard.temperatureFont)
                .scaledToFill()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            emptyText
            Text(viewModel.temperatureMaxMin)
                .font(Style.WeatherCard.temperatureMaxMinFont)
        }
    }

    var emptyText: some View {
        Text("")
    }

    var conditionsView: some View {
        HStack(spacing: 30) {
            VStack {
                Image(systemName: viewModel.sunrise.symbol)
                Text(viewModel.sunrise.getTime())
            }
            VStack {
                Image(systemName: viewModel.windSpeed.symbol)
                Text(viewModel.windSpeed.value)
            }
            VStack {
                Image(systemName: viewModel.humidity.symbol)
                Text(viewModel.humidity.value)
            }
            VStack {
                Image(systemName: viewModel.sunset.symbol)
                Text(viewModel.sunset.getTime())
            }
        }
        .font(Style.WeatherCard.conditionsFont)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CurrentWeatherCard(viewModel: CurrentWeatherCard.ViewModel())
        .padding(22.5)
}
