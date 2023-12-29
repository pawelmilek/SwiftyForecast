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
    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview
    @State private var isShowingSupportError = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    InfoRow(
                        tintColor: .blue,
                        symbol: "apps.iphone",
                        title: "Application",
                        content: Bundle.main.applicationName,
                        link: nil,
                        action: nil
                    )
                    InfoRow(
                        tintColor: .blue,
                        symbol: "gear",
                        title: "Version",
                        content: "\(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))",
                        link: nil,
                        action: nil
                    )
                    InfoRow(
                        tintColor: .blue,
                        symbol: "info.circle",
                        title: "Compatibility",
                        content: "iOS \(Bundle.main.minimumOSVersion)",
                        link: nil,
                        action: nil
                    )
                    DisclosureGroup {
                        Text("UIKit, SwiftUI, Combine, Charts, WidgetKit, MapKit, StoreKit, WebKit, TipKit")
                            .font(.footnote)
                            .fontWeight(.heavy)
                            .fontDesign(.monospaced)
                            .foregroundStyle(.primary)
                            .padding(.leading, 15)
                            .padding(.vertical, 10)
                    } label: {
                        InfoRow(
                            tintColor: .orange,
                            symbol: "swift",
                            title: "Frameworks",
                            content: nil,
                            link: nil,
                            action: nil
                        )
                    }
                    InfoRow(
                        tintColor: .green,
                        symbol: "ellipsis.curlybraces",
                        title: "Developer",
                        content: "Pawel Milek",
                        link: nil,
                        action: nil
                    )
                    InfoRow(
                        tintColor: Color(uiColor: .primary),
                        symbol: "globe",
                        title: "Website",
                        content: nil,
                        link: (
                            destination: "https://sites.google.com/view/pmilek/home",
                            label:  Bundle.main.applicationName
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
                        action: {
                            requestReview()
                        }
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
                isPresented: $isShowingSupportError
            ) {
                Button("OK") { }
            } message: {
                Text("Please, check your support email configuration and try again.")
            }
        }
    }

    private func reportFeedback() {
        if let recipient = try? ConfigurationSettingsAccessor.value(for: .supportEmailKey) {
            let feedbackEmail = SupportEmail(
                recipient: recipient,
                subject: "[Feedback] Swifty Forecast"
            )

            debugPrint(feedbackEmail.body)
            feedbackEmail.send(openURL: openURL)
        } else {
            isShowingSupportError.toggle()
        }
    }

    private func reportIssue() {
        if let recipient = try? ConfigurationSettingsAccessor.value(for: .supportEmailKey) {
            let bugEmail = SupportEmail(
                recipient: recipient,
                subject: "[Bug] Swifty Forecast"
            )
            debugPrint(bugEmail.body)
            bugEmail.send(openURL: openURL)
        } else {
            isShowingSupportError.toggle()
        }
    }

    private func openDataPrivacyPolicy() {
        openURL(URL(string: "https://sites.google.com/view/pmilek/home/privacy-policy")!)
    }

    private func openDataProvider() {
        openURL(URL(string: "https://openweathermap.org")!)
    }
}

#Preview {
    InformationView()
}
