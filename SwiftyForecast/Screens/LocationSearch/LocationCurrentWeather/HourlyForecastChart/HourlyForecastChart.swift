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
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(Color(uiColor: .tertiary))
                                AsyncImage(url: item.iconURL, content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 40, maxHeight: 40)
                                        .shadow(
                                            color: Color(uiColor: .shadow),
                                            radius: Style.WeatherCard.iconShadowRadius,
                                            x: Style.WeatherCard.iconShadowOffset.width,
                                            y: Style.WeatherCard.iconShadowOffset.height
                                        )
                                }, placeholder: {
                                    ProgressView()
                                        .frame(maxWidth: 40, maxHeight: 40)
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
                                lineWidth: 0.25,
                                miterLimit: 1,
                                dash: [],
                                dashPhase: 1
                            )
                        )
                        if let hour = value.as(String.self) {
                            AxisValueLabel {
                                Text(hour)
                                    .font(.footnote)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(Color(uiColor: .tertiary)).opacity(0.5)
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
        .groupBoxStyle(YellowGroupBoxStyle())
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
        .foregroundStyle(Color(uiColor: .tertiary))
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

struct YellowGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(.top, 40)
            .padding(.horizontal, 10)
            .background(.background)
            .cornerRadius(20)
            .overlay(
                configuration.label.padding(10),
                alignment: .topLeading
            )
    }
}
