//
//  AboutScreen.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/21/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import StoreKit

struct AboutScreen: View {
    @ObservedObject var viewModel: AboutViewModel
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    AboutRow(
                        tintColor: .customPrimary,
                        symbol: "apps.iphone",
                        title: "Application",
                        content: viewModel.appName
                    )
                    AboutRow(
                        tintColor: .customPrimary,
                        symbol: "gear",
                        title: "Version",
                        content: viewModel.appVersion
                    )
                    AboutRow(
                        tintColor: .customPrimary,
                        symbol: "info.circle",
                        title: "Compatibility",
                        content: viewModel.appCompatibility
                    )
                    ShareRow(
                        item: viewModel.shareURL(),
                        tintColor: .customPrimary
                    )
                } header: {
                    Text("App")
                }
                Section {
                    AboutLinkRow(
                        tintColor: .customPrimary,
                        symbol: "apps.iphone",
                        title: "Apps Preview",
                        url: viewModel.appStorePreviewURL
                    )
                    .simultaneousGesture(TapGesture().onEnded() {
                        viewModel.logEventRowTapped("Apps Preview")
                    })
                    .popoverTip(viewModel.appStorePreviewTip, arrowEdge: .bottom)
                    .foregroundStyle(.customPrimary)
                } header: {
                    Text("App Store")
                }
                Section {
                    ActionAboutRow(
                        tintColor: .customPrimary,
                        symbol: "envelope.fill",
                        title: "Contact",
                        action: reportFeedback
                    )
                    ActionAboutRow(
                        tintColor: .red,
                        symbol: "ant.fill",
                        title: "Report Issue",
                        action: reportIssue
                    )
                    AboutLinkRow(
                        tintColor: .yellow,
                        symbol: "star.fill",
                        title: "Rate Application",
                        url: viewModel.writeReviewURL
                    )
                    .simultaneousGesture(TapGesture().onEnded() {
                        viewModel.logEventRowTapped("Rate Application")
                    })
                } header: {
                    Text("Feedback")
                }

                Section {
                    AboutNavigationLinkRow(
                        tintColor: .customPrimary,
                        symbol: "doc.plaintext.fill",
                        title: "Licenses",
                        destination: {
                            LicenseView()
                        }
                    )
                    AboutLinkRow(
                        tintColor: .customPrimary,
                        symbol: "lock.shield.fill",
                        title: "Privacy Policy",
                        url: viewModel.privacyPolicyURL
                    )
                    .simultaneousGesture(TapGesture().onEnded() {
                        viewModel.logEventRowTapped("Privacy Policy")
                    })
                } header: {
                    Text("Documents")
                }

                Section {
                    AboutLinkRow(
                        tintColor: .customPrimary,
                        symbol: "sun.haze.fill",
                        title: "OpenWeather",
                        url: viewModel.weatherDataProviderURL
                    )
                } header: {
                    Text("Data Provider")
                } footer: {
                    CopyrightFooterView(year: viewModel.currentYear)
                        .padding(.top, 10)
                }
            }
            .padding(.top, 0.25)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        viewModel.donateDidAppBecomeActiveEvent()
                    } label: {
                        Text("Done")
                            .fontDesign(.monospaced)
                            .fontWeight(.semibold)
                    }
                    .tint(.accent)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.small)
                }
            }
        }
        .onAppear {
            viewModel.logEventScreen(
                "About Screen",
                className: "\(type(of: self))"
            )
        }
    }

    private func reportFeedback() {
        viewModel.reportFeedback(openURL)
    }

    private func reportIssue() {
        viewModel.reportIssue(openURL)
    }
}

#Preview {
    AboutScreen(viewModel: .init())
}
