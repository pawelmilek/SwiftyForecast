//
//  AppearanceView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI

struct AppearanceView: View {
    @AppStorage("appearanceTheme") private var appearanceTheme: AppearanceTheme = .systemDefault
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var analyticsManager = AnalyticsManager(service: FirebaseAnalyticsService())
    @State private var circleOffset = CGSize.zero

    var onAppearanceChange: () -> Void

    var body: some View {
        VStack(spacing: 35) {
            Circle().fill(appearanceTheme.color(colorScheme).gradient)
                .frame(maxWidth: 150, maxHeight: 150)
                .mask {
                    Rectangle()
                        .overlay {
                            Circle()
                                .offset(x: circleOffset.width, y: circleOffset.height)
                                .blendMode(.destinationOut)
                        }
                }
            VStack(spacing: 10) {
                Text("Appearance")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("Choose a day or night.\nCustomize your interface.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.accent)
            .fontDesign(.monospaced)
            Picker("User Theme Settings", selection: $appearanceTheme) {
                ForEach(AppearanceTheme.allCases, id: \.self) { item in
                    Text(item.rawValue)
                        .foregroundStyle(.accent)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: Constant.height)
        .background(Color(.systemBackground))
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .environment(\.colorScheme, colorScheme)
        .onAppear {
            let isDark = colorScheme == .dark
            setCircleOffset(isDark: isDark)
        }
        .onChange(of: colorScheme) {
            let isDark = colorScheme == .dark
            setCircleOffset(isDark: isDark)
            logColorShemeSwitched(colorScheme)
        }
        .onChange(of: appearanceTheme) {
            let isDark = appearanceTheme == .dark
            setCircleOffset(isDark: isDark)
            onAppearanceChange()
        }.onAppear {
            logScreenViewed()
        }
    }

    private func logScreenViewed() {
        analyticsManager.send(
            event: ScreenAnalyticsEvent.screenViewed(
                name: "Appearance Screen",
                className: "\(type(of: self))"
            )
        )
    }

    private func logColorShemeSwitched(_ colorScheme: ColorScheme) {
        analyticsManager.send(
            event: AppearanceViewEvent.colorSchemeSwitched(
                name: String(describing: colorScheme)
            )
        )
    }

    private func setCircleOffset(isDark: Bool) {
        withAnimation(.bouncy) {
            circleOffset = CGSize(
                width: isDark ? 30 : 150,
                height: isDark ? -25 : -150
            )
        }
    }

    enum Constant {
        static let height = CGFloat(410)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AppearanceView { }
}
