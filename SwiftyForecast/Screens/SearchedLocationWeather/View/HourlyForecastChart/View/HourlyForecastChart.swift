//
//  HourlyForecastChart.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import Charts

struct HourlyForecastChart: View {
    @ObservedObject var viewModel: HourlyForecastChartViewModel

    let curGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .customPrimary.opacity(0.5),
                .customPrimary.opacity(0.2),
                .customPrimary.opacity(0.05)
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        GroupBox {
            ScrollView(.horizontal, showsIndicators: false) {
                Chart {
                    ForEach(viewModel.dataSource) { item in
                        AreaMark(
                            x: .value("Hour", item.hour),
                            y: .value("Temperature", item.currentTemperature)
                        )
                        .foregroundStyle(curGradient)
                        .interpolationMethod(.catmullRom)

                        LineMark(
                            x: .value("Hour", item.hour),
                            y: .value("Temperature", item.currentTemperature)
                        )
                        .foregroundStyle(Color(.customPrimary))
                        .interpolationMethod(.catmullRom)
                        .symbol {
                            VStack(spacing: 0) {
                                Text(item.temperatureFormatted)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.accent)
                                    .modifier(TextScaledModifier())
                                AsyncImage(url: item.iconURL, content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 35, maxHeight: 35)
                                        .shadow(
                                            color: Color(.shadow),
                                            radius: Style.WeatherCard.iconShadowRadius,
                                            x: Style.WeatherCard.iconShadowOffset.width,
                                            y: Style.WeatherCard.iconShadowOffset.height
                                        )
                                }, placeholder: {
                                    ProgressView()
                                        .frame(maxWidth: 35, maxHeight: 35)
                                })
                                .padding(.horizontal, 0)
                                .padding(.vertical, -8)
                            }
                            .offset(y: -12)
                        }

                    }
                }
                .chartXAxis {
                    AxisMarks(preset: .aligned, position: .top) { value in
                        AxisGridLine(
                            centered: true,
                            stroke: StrokeStyle(
                                lineWidth: 0.5,
                                miterLimit: 1,
                                dash: [1, 2],
                                dashPhase: 1
                            )
                        )
                        if let hour = value.as(String.self) {
                            AxisValueLabel {
                                Text(hour)
                                    .font(.footnote)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.accent).opacity(0.5)
                            }
                        }
                    }
                }
                .chartYAxis(.hidden)
                .chartYScale(
                    domain: viewModel.chartYScaleRange.lowerBound...viewModel.chartYScaleRange.upperBound
                )
                .frame(
                    width: HourlyForecastChartViewModel.dataPointWidth * CGFloat(viewModel.numberOfHours)
                )
            }
        } label: {
            headerView
        }
        .groupBoxStyle(BackgroundGroupBoxStyle())
        .frame(maxHeight: HourlyForecastChartViewModel.chartHeight)

    }
}

private extension HourlyForecastChart {
    var headerView: some View {
        HStack(spacing: 5) {
            Image(systemName: "clock")
            Text("Hourly Forecast")
        }
        .font(.footnote)
        .fontWeight(.semibold)
        .fontDesign(.monospaced)
        .foregroundStyle(.accent)
    }
}

#Preview {
    HourlyForecastChart(
        viewModel: HourlyForecastChartViewModel(
            models: MockGenerator(
                decoder: JSONDecoder(),
                parser: ResponseParser()
            )
            .generateForecastWeatherModel().hourly
        )
    )
    .padding(22.5)
}
