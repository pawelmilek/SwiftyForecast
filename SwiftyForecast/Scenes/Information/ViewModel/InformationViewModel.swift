//
//  InformationViewModel.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
final class InformationViewModel: ObservableObject {
    private enum Constant {
        static let appURLString = "https://sites.google.com/view/pmilek/swifty-forecast"
        static let privacyPolicyURLString = "https://sites.google.com/view/pmilek/privacy-policy"
        static let writeReviewURLString = "https://apps.apple.com/app/id1161186194?action=write-review"
        static let dataProviderURLString = "https://openweathermap.org"
    }

    @Published var isShowingSupportError = false
    @Published private(set) var appName = ""
    @Published private(set) var appVersion = ""
    @Published private(set) var appCompatibility = ""
    @Published private(set) var appURLString = ""
    @Published private(set) var copyright = ""
    @Published private(set) var frameworks = [String]()

    private let recipient: String?
    private let privacyPolicyURL: URL
    private let writeReviewURL: URL
    private let dataProviderURL: URL

    init() {
        appName = Bundle.applicationName
        appVersion = "\(Bundle.versionNumber) (\(Bundle.buildNumber))"
        appCompatibility = "iOS \(Bundle.minimumOSVersion)"
        appURLString = Constant.appURLString
        recipient = try? ConfigurationSettingsAccessor.value(for: .supportEmailKey)
        privacyPolicyURL = URL(string: Constant.privacyPolicyURLString)!
        writeReviewURL = URL(string: Constant.writeReviewURLString)!
        dataProviderURL = URL(string: Constant.dataProviderURLString)!
        copyright = "Copyright © All right reserved."
        frameworks = [
            "UIKit",
            "SwiftUI",
            "Combine",
            "Charts",
            "WidgetKit",
            "MapKit",
            "StoreKit",
            "WebKit",
            "TipKit"
        ]
    }

    func reportFeedback(_ openURL: OpenURLAction) {
        guard let recipient else {
            isShowingSupportError.toggle()
            return
        }

        let feedbackEmail = SupportEmail(
            recipient: recipient,
            subject: "[Feedback] Swifty Forecast"
        )

        feedbackEmail.send(openURL: openURL)
    }

    func reportIssue(_ openURL: OpenURLAction) {
        guard let recipient else {
            isShowingSupportError.toggle()
            return
        }
        let bugEmail = SupportEmail(
            recipient: recipient,
            subject: "[Bug] Swifty Forecast"
        )
        bugEmail.send(openURL: openURL)
    }

    func openDataPrivacyPolicy(_ openURL: OpenURLAction) {
        openURL(privacyPolicyURL)
    }

    func openWriteReview(_ openURL: OpenURLAction) {
        openURL(writeReviewURL)
    }

    func openDataProvider(_ openURL: OpenURLAction) {
        openURL(dataProviderURL)
    }
}
