//
//  WeatherCardView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct WeatherCardView: View {
    @ObservedObject var viewModel: WeatherCardViewViewModel

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
                AnimationView(condition: viewModel.condition)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Style.WeatherCard.cornerRadius,
                    style: .continuous
                )
                .inset(by: 2.5)
            )
            .shadow(
                color: Style.WeatherCard.shadowColor,
                radius: Style.WeatherCard.shadowRadius,
                x: Style.WeatherCard.shadow.x,
                y: Style.WeatherCard.shadow.y
            )
        }
        .frame(maxHeight: 250)
        .task {
            await viewModel.loadData()
        }
    }
}

private extension WeatherCardView {

    var locationNameView: some View {
        Text(viewModel.name)
            .font(Style.WeatherCard.locationNameFont)
            .id(viewModel.name)
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
                Image(.cloudyDay)
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
                .textScaled()
        }
        .font(Style.WeatherCard.dayDescriptionFont)
    }

    var temperatureView: some View {
        VStack(spacing: 0) {
            Text(viewModel.temperature)
                .font(Style.WeatherCard.temperatureFont)
                .textScaled()
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
        HStack(spacing: 0) {
            VStack {
                Image(systemName: viewModel.sunrise.symbol)
                Text(viewModel.sunrise.getTime())
            }
            .id(viewModel.sunrise.getTime())
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
            .frame(maxWidth: .infinity)
            VStack {
                Image(systemName: viewModel.windSpeed.symbol)
                Text(viewModel.windSpeed.value)
            }
            .id(viewModel.windSpeed.value)
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
            .frame(maxWidth: .infinity)
            VStack {
                Image(systemName: viewModel.humidity.symbol)
                Text(viewModel.humidity.value)
            }
            .id(viewModel.humidity.value)
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
            .frame(maxWidth: .infinity)
            VStack {
                Image(systemName: viewModel.sunset.symbol)
                Text(viewModel.sunset.getTime())
            }
            .id(viewModel.sunset.getTime())
            .transition(.blurReplace.animation(.easeOut(duration: 0.5)))
            .frame(maxWidth: .infinity)
        }
        .font(Style.WeatherCard.conditionsFont)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    WeatherCardView(
        viewModel: CompositionRoot.cardViewModel(
            latitude: LocationModel.examples.first!.latitude,
            longitude: LocationModel.examples.first!.longitude,
            name: LocationModel.examples.first!.name
        )
    )
    .padding(22.5)
}
