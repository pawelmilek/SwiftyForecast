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
    @Published private(set) var appName = ""
    @Published private(set) var appVersion = ""
    @Published private(set) var appCompatibility = ""
    @Published private(set) var appURLString = ""
    @Published private(set) var appStorePreviewURLString = ""
    @Published private(set) var currentYear = ""
    @Published private(set) var frameworks = [String]()
    @Published private var bundle: Bundle
    @Published private var buildConfigurationFile: BuildConfigurationFile
    private let networkResourceFactory: NetworkResourceFactoryProtocol
    private var appId = 0

    private var cancellables = Set<AnyCancellable>()

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
        self.currentYear = Date.now.formatted(.dateTime.year())
        self.frameworks = [
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

        subscribeToPublishers()
    }

    private func subscribeToPublishers() {
        $bundle
            .sink { [weak self] bundle in
                guard let self else { return }
                appName = bundle.applicationName
                appVersion = "\(bundle.versionNumber) (\(bundle.buildNumber))"
                appCompatibility = "iOS \(bundle.minimumOSVersion)"
            }
            .store(in: &cancellables)

        $buildConfigurationFile
            .sink { [weak self] buildConfigurationFile in
                guard let self else { return }
                appId = buildConfigurationFile.appId()
                appURLString = NetworkResourceType.appShare(appId: appId).stringURL
                appStorePreviewURLString = NetworkResourceType.appStorePreview.stringURL
            }
            .store(in: &cancellables)
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

    func shareURL() -> URL {
        guard let url = URL(string: NetworkResourceType.appShare(appId: appId).stringURL) else {
            fatalError()
        }

        return url
    }
}
