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
    @Published private(set) var appURL: URL?
    @Published private(set) var appStorePreviewURL: URL?
    @Published private(set) var writeReviewURL: URL?
    @Published private(set) var privacyPolicyURL: URL?
    @Published private(set) var weatherDataProviderURL: URL?
    @Published private(set) var currentYear = ""
    @Published private var bundle: Bundle
    @Published private var buildConfiguration: BuildConfigurationFile
    private let networkResourceFactory: NetworkResourceFactoryProtocol
    private let analytics: AnalyticsAboutSendable
    private let toolbarInteractive: ToolbarInteractive
    private var cancellables = Set<AnyCancellable>()
    private var appId = 0
    let appStorePreviewTip = AppStorePreviewTip()

    init(
        bundle: Bundle,
        buildConfiguration: BuildConfigurationFile,
        networkResourceFactory: NetworkResourceFactoryProtocol,
        analytics: AnalyticsAboutSendable,
        toolbarInteractive: ToolbarInteractive
    ) {
        self.bundle = bundle
        self.buildConfiguration = buildConfiguration
        self.networkResourceFactory = networkResourceFactory
        self.analytics = analytics
        self.toolbarInteractive = toolbarInteractive
        self.currentYear = Date.now.formatted(.dateTime.year())
        subscribeToPublishers()
    }

    func doneItemTapped() {
        toolbarInteractive.doneItemTapped()
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

        $buildConfiguration
            .sink { [weak self] buildConfigurationFile in
                guard let self else { return }
                appId = buildConfigurationFile.appId()
                appURL = try? networkResourceFactory.make(by: .appShare(appId: appId)).content()
                appStorePreviewURL = try? networkResourceFactory.make(by: .appStorePreview).content()
                writeReviewURL = try? networkResourceFactory.make(by: .appStoreReview(appId: appId)).content()
                privacyPolicyURL = try? networkResourceFactory.make(by: .privacyPolicy).content()
                weatherDataProviderURL = try? networkResourceFactory.make(by: .weatherService).content()
            }
            .store(in: &cancellables)
    }

    func reportFeedback(_ openURL: OpenURLAction) {
        let feedbackEmail = SupportEmail(
            bundle: bundle,
            recipient: buildConfiguration.supportEmailAddress(),
            subject: "[Feedback] \(bundle.applicationName)"
        )

        feedbackEmail.send(openURL: openURL)
    }

    func reportIssue(_ openURL: OpenURLAction) {
        let bugEmail = SupportEmail(
            bundle: bundle,
            recipient: buildConfiguration.supportEmailAddress(),
            subject: "[Bug] \(bundle.applicationName)"
        )
        bugEmail.send(openURL: openURL)
    }

    func shareURL() -> URL {
        guard let url = URL(string: NetworkResourceType.appShare(appId: appId).stringURL) else {
            fatalError()
        }

        return url
    }

    func sendEventRowTapped(_ title: String) {
        let event = AboutAnalyticsEvent.rowTapped(title: title)
        analytics.send(name: event.name, metadata: event.metadata)
    }

    func sendEventScreen(className: String) {
        let event = AboutAnalyticsEvent.screenViewed(className: className)
        analytics.send(name: event.name, metadata: event.metadata)
    }

}
