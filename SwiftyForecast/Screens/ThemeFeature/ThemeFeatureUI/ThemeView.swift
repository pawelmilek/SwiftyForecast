//
//  ThemeView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable switch_case_alignment

import SwiftUI

struct ThemeView: View {
    @AppStorage("appearanceTheme") private var appearanceTheme = Theme.systemDefault
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: ThemeViewModel
    @State private var gradientColor: AnyGradient?

    let textColor: Color
    let darkScheme: Color
    let lightScheme: Color

    var body: some View {
        VStack(spacing: 35) {
            circleView
            descriptionView
            themePickerView
        }
        .frame(maxWidth: .infinity, maxHeight: viewModel.height)
        .background(Color(.systemBackground))
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .environment(\.colorScheme, colorScheme)
        .onChange(of: colorScheme, initial: true) {
            setupGradient()
            setupCircleOffset()
        }
        .onChange(of: appearanceTheme) {
            setupGradient()
            setupCircleOffset()
            viewModel.postThemeChanged()
            viewModel.sendColorSchemeSwitched(String(describing: colorScheme))
        }
        .onAppear {
            viewModel.sendScreenViewed()
        }
        .animation(.bouncy, value: viewModel.circleOffset)
    }

    private func setupCircleOffset() {
        switch appearanceTheme {
        case .systemDefault:
            colorScheme == .dark
            ? viewModel.setDarkCircleOffset()
            : viewModel.setLightCircleOffset()

        case .light:
            viewModel.setLightCircleOffset()

        case .dark:
            viewModel.setDarkCircleOffset()
        }
    }

    private func setupGradient() {
        gradientColor = switch appearanceTheme {
        case .systemDefault:
            colorScheme == .dark
            ? darkScheme.gradient
            : lightScheme.gradient

        case .light:
            lightScheme.gradient

        case .dark:
            darkScheme.gradient
        }
    }

    private var circleView: some View {
        Circle()
            .fill(gradientColor ?? darkScheme.gradient)
            .frame(maxWidth: 150, maxHeight: 150)
            .mask {
                Rectangle()
                    .overlay {
                        Circle()
                            .offset(
                                x: viewModel.circleOffset.width,
                                y: viewModel.circleOffset.height
                            )
                            .blendMode(.destinationOut)
                    }
            }
    }

    private var descriptionView: some View {
        VStack(spacing: 10) {
            Text(viewModel.title)
                .font(.title3)
                .fontWeight(.bold)
            Text(viewModel.subtitle)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(textColor)
        .fontDesign(.monospaced)
    }

    private var themePickerView: some View {
        Picker(viewModel.pickerTitle, selection: $appearanceTheme) {
            ForEach(viewModel.themes) { item in
                Text(item.rawValue)
                    .foregroundStyle(textColor)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 40)
        .padding(.vertical, 10)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ThemeView(
        viewModel: ThemeViewModel(
            notification: PreviewThemeNotificationChange(),
            analytics: PreviewAnalyticsTheme()
        ),
        textColor: .black,
        darkScheme: .red,
        lightScheme: .green
    )
}

struct PreviewThemeNotificationChange: ThemeChangeNotifiable {
    func notify() { }
}

struct PreviewAnalyticsTheme: AnalyticsThemeSendable {
    func send(name: String, metadata: [String : Any]) { }
}
