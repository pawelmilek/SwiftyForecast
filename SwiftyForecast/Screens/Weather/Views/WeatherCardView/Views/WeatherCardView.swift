//
//  WeatherCardView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct WeatherCardView: View {
    private struct Style {
        static let cornerRadius: CGFloat = 25
        static let shadowColor = Color(.shadow)
        static let shadowRadius = CGFloat(0)
        static let shadow = (x: CGFloat(2.5), y: CGFloat(2.5))
        static let textColor = Color.white

        static let locationNameFont = Font.system(.title2, design: .monospaced, weight: .heavy)
        static let dayDescriptionFont = Font.system(.footnote, design: .monospaced, weight: .semibold)
        static let temperatureFont = Font.system(size: 80, weight: .black, design: .monospaced)
        static let temperatureMaxMinFont = Font.system(.footnote, design: .monospaced, weight: .black)
        static let conditionsFont = Font.system(.caption2, design: .monospaced, weight: .light)

        static let iconShadowRadius = CGFloat(0.5)
        static let iconShadowOffset = CGSize(width: 1, height: 1)
        static let iconShadowColor = Color.white
    }

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
            .foregroundStyle(Style.textColor)
            .padding(15)
            .background(
                // TODO: Enable Animation faeture after Dependency Injection and Composition Root is finished.
                AnimationView(condition: .none /*viewModel.condition*/)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Style.cornerRadius,
                    style: .continuous
                )
                .inset(by: 2.5)
            )
            .shadow(
                color: Style.shadowColor,
                radius: Style.shadowRadius,
                x: Style.shadow.x,
                y: Style.shadow.y
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
            .font(Style.locationNameFont)
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
            color: Style.iconShadowColor,
            radius: Style.iconShadowRadius,
            x: Style.iconShadowOffset.width,
            y: Style.iconShadowOffset.height
        )
    }

    var dayDescriptionView: some View {
        VStack {
            Text(viewModel.daytimeDescription)
            Text(viewModel.description)
                .textScaled()
        }
        .font(Style.dayDescriptionFont)
    }

    var temperatureView: some View {
        VStack(spacing: 0) {
            Text(viewModel.temperature)
                .font(Style.temperatureFont)
                .textScaled()
            VStack {
                Text("")
                Text(viewModel.temperatureMaxMin)
            }
            .font(Style.temperatureMaxMinFont)
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
        .font(Style.conditionsFont)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    WeatherCardView(
        viewModel: .init(
            latitude: LocationModel.examples.first!.latitude,
            longitude: LocationModel.examples.first!.longitude,
            name: LocationModel.examples.first!.name,
            service: WeatherService(
                repository: WeatherRepository(
                    client: OpenWeatherClient(
                        decoder: JSONSnakeCaseDecoded()
                    )
                ),
                parse: WeatherResponseParser()
            ),
            temperatureFormatterFactory: TemperatureFormatterFactory(notationStorage: NotationSettingsStorage()),
            speedFormatterFactory: SpeedFormatterFactory(notationStorage: NotationSettingsStorage()),
            metricSystemNotification: MetricSystemNotificationAdapter(notificationCenter: .default)
        )
    )
    .padding(22.5)
}
