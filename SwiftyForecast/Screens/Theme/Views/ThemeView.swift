//
//  ThemeView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: ThemeViewViewModel

    var body: some View {
        VStack(spacing: 35) {
            Circle()
                .fill(viewModel.gradientColor(for: colorScheme))
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
            VStack(spacing: 10) {
                Text(viewModel.title)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(viewModel.subtitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.accent)
            .fontDesign(.monospaced)
            Picker(viewModel.pickerTitle, selection: $viewModel.selectedTheme) {
                ForEach(viewModel.themes) { item in
                    Text(item.rawValue)
                        .foregroundStyle(.accent)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: viewModel.height)
        .background(Color(.systemBackground))
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .environment(\.colorScheme, colorScheme)
        .onChange(of: colorScheme) {
            viewModel.setCircleOffset(isDark: colorScheme == .dark)
            viewModel.logColorShemeSwitched(colorScheme)
        }
        .onAppear {
            viewModel.setCircleOffset(isDark: colorScheme == .dark)
            viewModel.logScreenViewed()
        }
        .animation(.bouncy, value: viewModel.circleOffset)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ThemeView(viewModel: CompositionRoot.themeViewModel)
}
