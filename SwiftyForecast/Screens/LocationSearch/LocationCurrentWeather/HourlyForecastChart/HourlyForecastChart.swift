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
    @ObservedObject var viewModel: ViewModel

    var background: Color {
        Color(uiColor: .primary).opacity(0.5)
    }

    var body: some View {
        GroupBox {
            ScrollView(.horizontal, showsIndicators: false) {
                Chart {
                    ForEach(viewModel.dataSource) { item in
                        LineMark(
                            x: .value("Hour", item.hour),
                            y: .value("Temperature", item.temperatureValue)
                        )
                        .foregroundStyle(Color(.primary))
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
                                            color: Color(uiColor: .shadow),
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
                            .background(.background)
                            .offset(y: -5)
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
                .chartYScale(domain: viewModel.chartYScaleRange.lowerBound...viewModel.chartYScaleRange.upperBound)
                .frame(width: ViewModel.dataPointWidth * CGFloat(viewModel.numberOfHours))
            }
        } label: {
            headerView
        }
        .groupBoxStyle(BackgroundGroupBoxStyle())
        .frame(maxHeight: ViewModel.chartHeight)
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
        viewModel: HourlyForecastChart.ViewModel(
            models: MockModelGenerator.generateForecastWeatherModel().hourly
        )
    )
    .padding(22.5)
}
