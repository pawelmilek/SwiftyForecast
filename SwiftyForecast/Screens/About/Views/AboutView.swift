//
//  AboutView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/21/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    @StateObject private var viewModel = AboutViewModel()
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                Section {
                    AboutRow(
                        tintColor: .blue,
                        symbol: "apps.iphone",
                        title: "Application",
                        label: viewModel.appName,
                        link: nil,
                        action: nil
                    )
                    AboutRow(
                        tintColor: .blue,
                        symbol: "gear",
                        title: "Version",
                        label: viewModel.appVersion,
                        link: nil,
                        action: nil
                    )
                    AboutRow(
                        tintColor: .blue,
                        symbol: "info.circle",
                        title: "Compatibility",
                        label: viewModel.appCompatibility,
                        link: nil,
                        action: nil
                    )
                    AboutFrameworkView(
                        title: "Frameworks",
                        content: viewModel.frameworks
                    )
                    AboutRow(
                        tintColor: .blue,
                        symbol: "ellipsis.curlybraces",
                        title: "Developer",
                        label: "Pawel Milek",
                        link: nil,
                        action: nil
                    )
                    AboutRow(
                        tintColor: Color(.customPrimary),
                        symbol: "globe",
                        title: "Website",
                        label: nil,
                        link: (
                            destination: viewModel.appURLString,
                            label: viewModel.appName
                        ),
                        action: nil
                    )
                } header: {
                    Text("About the app")
                }
                Section {
                    AboutRow(
                        tintColor: .blue,
                        symbol: "apps.iphone",
                        title: "Apps Preview",
                        label: nil,
                        link: (
                            destination: viewModel.appStorePreviewURLString,
                            label: ""
                        ),
                        action: nil
                    )
                    .popoverTip(AppStorePreviewTip(), arrowEdge: .bottom)
                } header: {
                    Text("App Store")
                }
                Section {
                    AboutRow(
                        tintColor: .blue,
                        symbol: "envelope.fill",
                        title: "Contact",
                        label: nil,
                        link: nil,
                        action: reportFeedback
                    )
                    AboutRow(
                        tintColor: .red,
                        symbol: "ant.fill",
                        title: "Report Issue",
                        label: nil,
                        link: nil,
                        action: reportIssue
                    )
                    AboutRow(
                        tintColor: .yellow,
                        symbol: "star.fill",
                        title: "Rate Application",
                        label: nil,
                        link: nil,
                        action: requestReview
                    )
                } header: {
                    Text("Feedback")
                }

                Section {
                    NavigationLink {
                        LicenseView()
                    } label: {
                        AboutRow(
                            tintColor: .blue,
                            symbol: "doc.plaintext.fill",
                            title: "Licenses",
                            label: nil,
                            link: nil,
                            action: nil
                        )
                    }
                    AboutRow(
                        tintColor: .blue,
                        symbol: "lock.shield.fill",
                        title: "Privacy Policy",
                        label: nil,
                        link: nil,
                        action: openDataPrivacyPolicy
                    )
                } header: {
                    Text("Documents")
                }

                Section {
                    AboutRow(
                        tintColor: .orange,
                        symbol: "sun.haze.fill",
                        title: "OpenWeather",
                        label: nil,
                        link: nil,
                        action: openDataProvider
                    )
                } header: {
                    Text("Data Provider")
                } footer: {
                    CopyrightFooterView(year: viewModel.currentYear)
                        .padding(.top, 10)
                }
            }
            .padding(.top, 1)
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func reportFeedback() {
        viewModel.reportFeedback(openURL)
    }

    private func reportIssue() {
        viewModel.reportIssue(openURL)
    }

    private func openDataPrivacyPolicy() {
        viewModel.openPrivacyPolicy(openURL)
    }

    private func openDataProvider() {
        viewModel.openWeatherService(openURL)
    }

    private func requestReview() {
        viewModel.openAppStoreReview(openURL)
    }
}

#Preview {
    AboutView()
}
