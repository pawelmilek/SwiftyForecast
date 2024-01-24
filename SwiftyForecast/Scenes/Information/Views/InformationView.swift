//
//  InformationView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/21/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import StoreKit

struct InformationView: View {
    @StateObject private var viewModel = InformationViewModel()
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                Section {
                    InfoRow(
                        tintColor: .blue,
                        symbol: "apps.iphone",
                        title: "Application",
                        content: viewModel.appName,
                        link: nil,
                        action: nil
                    )
                    InfoRow(
                        tintColor: .blue,
                        symbol: "gear",
                        title: "Version",
                        content: viewModel.appVersion,
                        link: nil,
                        action: nil
                    )
                    InfoRow(
                        tintColor: .blue,
                        symbol: "info.circle",
                        title: "Compatibility",
                        content: viewModel.appCompatibility,
                        link: nil,
                        action: nil
                    )
                    InfromationFrameworkView(
                        title: "Frameworks",
                        content: viewModel.frameworks
                    )
                    InfoRow(
                        tintColor: .green,
                        symbol: "ellipsis.curlybraces",
                        title: "Developer",
                        content: "Pawel Milek",
                        link: nil,
                        action: nil
                    )
                    InfoRow(
                        tintColor: Color(.customPrimary),
                        symbol: "globe",
                        title: "Website",
                        content: nil,
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
                    InfoRow(
                        tintColor: .blue,
                        symbol: "envelope.fill",
                        title: "Contact",
                        content: nil,
                        link: nil,
                        action: reportFeedback
                    )
                    InfoRow(
                        tintColor: .red,
                        symbol: "ant.fill",
                        title: "Report Issue",
                        content: nil,
                        link: nil,
                        action: reportIssue
                    )
                    InfoRow(
                        tintColor: .yellow,
                        symbol: "star.fill",
                        title: "Rate Application",
                        content: nil,
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
                        InfoRow(
                            tintColor: .blue,
                            symbol: "doc.plaintext.fill",
                            title: "Licenses",
                            content: nil,
                            link: nil,
                            action: nil
                        )
                    }
                    InfoRow(
                        tintColor: .blue,
                        symbol: "lock.shield.fill",
                        title: "Privacy Policy",
                        content: nil,
                        link: nil,
                        action: openDataPrivacyPolicy
                    )
                } header: {
                    Text("Documents")
                }

                Section {
                    InfoRow(
                        tintColor: .orange,
                        symbol: "sun.haze.fill",
                        title: "OpenWeather",
                        content: nil,
                        link: nil,
                        action: openDataProvider
                    )
                } header: {
                    Text("Data Provider")
                } footer: {
                    HStack {
                        Text("Copyright © All right reserved.")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.top, 1)
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Support",
                isPresented: $viewModel.isShowingSupportError
            ) {
                Button("OK") { }
            } message: {
                Text("Please, check your support email configuration and try again.")
            }
        }
    }

    private func reportFeedback() {
        viewModel.reportFeedback(openURL)
    }

    private func reportIssue() {
        viewModel.reportIssue(openURL)
    }

    private func openDataPrivacyPolicy() {
        viewModel.openDataPrivacyPolicy(openURL)
    }

    private func openDataProvider() {
        viewModel.openDataProvider(openURL)
    }

    private func requestReview() {
        viewModel.openWriteReview(openURL)
    }
}

#Preview {
    InformationView()
}
