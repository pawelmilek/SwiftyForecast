//
//  AboutViewModel.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
final class AboutViewModel: ObservableObject {
    @Published private(set) var appName: String
    @Published private(set) var appVersion: String
    @Published private(set) var appCompatibility: String
    @Published private(set) var appURLString: String
    @Published private(set) var appStorePreviewURLString: String
    @Published private(set) var currentYear: String
    @Published private(set) var frameworks: [String]

    private let bundle: Bundle
    private let buildConfigurationFile: BuildConfigurationFile
    private let networkResourceFactory: NetworkResourceFactoryProtocol
    private let appId: Int

    convenience init() {
        self.init(
            bundle: .main,
            buildConfigurationFile: .init(),
            networkResourceFactory: NetworkResourceFactory()
        )
    }

    init(
        bundle: Bundle,
        buildConfigurationFile: BuildConfigurationFile,
        networkResourceFactory: NetworkResourceFactoryProtocol
    ) {
        self.bundle = bundle
        self.buildConfigurationFile = buildConfigurationFile
        self.networkResourceFactory = networkResourceFactory

        appName = bundle.applicationName
        appVersion = "\(bundle.versionNumber) (\(bundle.buildNumber))"
        appCompatibility = "iOS \(bundle.minimumOSVersion)"
        appId = buildConfigurationFile.appId()

        appURLString = NetworkResourceType.appShare(appId: appId).stringURL
        appStorePreviewURLString = NetworkResourceType.appStorePreview.stringURL
        currentYear = Date.now.formatted(.dateTime.year())
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
        let feedbackEmail = SupportEmail(
            bundle: bundle,
            recipient: buildConfigurationFile.supportEmailAddress(),
            subject: "[Feedback] \(bundle.applicationName)"
        )

        feedbackEmail.send(openURL: openURL)
    }

    func reportIssue(_ openURL: OpenURLAction) {
        let bugEmail = SupportEmail(
            bundle: bundle,
            recipient: buildConfigurationFile.supportEmailAddress(),
            subject: "[Bug] \(bundle.applicationName)"
        )
        bugEmail.send(openURL: openURL)
    }

    func openPrivacyPolicy(_ openURL: OpenURLAction) {
        let privacyPolicy = networkResourceFactory.make(by: .privacyPolicy)
        guard let url = try? privacyPolicy.content() else { return }
        openURL(url)
    }

    func openAppStoreReview(_ openURL: OpenURLAction) {
        let writeReview = networkResourceFactory.make(by: .appStoreReview(appId: appId))
        guard let url = try? writeReview.content() else { return }
        openURL(url)
    }

    func openWeatherService(_ openURL: OpenURLAction) {
        let weatherService = networkResourceFactory.make(by: .weatherService)
        guard let url = try? weatherService.content() else { return }
        openURL(url)
    }
}
