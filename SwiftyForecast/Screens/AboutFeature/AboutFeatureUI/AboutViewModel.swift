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
    @Published private var buildConfiguration: BuildConfigurationContent
    private let appInfo: ApplicationInfo
    private let networkResourceFactory: NetworkResourceFactoryProtocol
    private let analytics: AnalyticsAboutSendable
    private let toolbarInteractive: ToolbarInteractive
    private var cancellables = Set<AnyCancellable>()
    private var appId = 0
    let appStorePreviewTip = AppStorePreviewTip()

    init(
        appInfo: ApplicationInfo,
        buildConfiguration: BuildConfigurationContent,
        networkResourceFactory: NetworkResourceFactoryProtocol,
        analytics: AnalyticsAboutSendable,
        toolbarInteractive: ToolbarInteractive
    ) {
        self.appInfo = appInfo
        self.buildConfiguration = buildConfiguration
        self.networkResourceFactory = networkResourceFactory
        self.analytics = analytics
        self.toolbarInteractive = toolbarInteractive
        self.currentYear = Date.now.formatted(.dateTime.year())
        self.appName = appInfo.name
        self.appVersion = appInfo.version
        self.appCompatibility = appInfo.compatibility
        subscribeToPublishers()
    }

    func doneItemTapped() {
        toolbarInteractive.doneItemTapped()
    }

    private func subscribeToPublishers() {
        $buildConfiguration
            .sink { [weak self] buildConfiguration in
                guard let self else { return }
                appId = buildConfiguration.appId()
                appURL = try? networkResourceFactory.make(by: .appShare(appId: appId)).contentURL()
                appStorePreviewURL = try? networkResourceFactory.make(by: .appStorePreview).contentURL()
                writeReviewURL = try? networkResourceFactory.make(by: .appStoreReview(appId: appId)).contentURL()
                privacyPolicyURL = try? networkResourceFactory.make(by: .privacyPolicy).contentURL()
                weatherDataProviderURL = try? networkResourceFactory.make(by: .weatherService).contentURL()
            }
            .store(in: &cancellables)
    }

    func reportFeedback(_ openURL: OpenURLAction) {
        let feedbackEmail = SupportEmail(
            body: SupportEmail.Body(
                appName: appInfo.name,
                appVersion: appInfo.version,
                deviceName: appInfo.device,
                systemInfo: appInfo.system
            ),
            recipient: buildConfiguration.supportEmailAddress(),
            subject: "[Feedback] \(appInfo.name)"
        )

        feedbackEmail.send(openURL: openURL)
    }

    func reportIssue(_ openURL: OpenURLAction) {
        let bugEmail = SupportEmail(
            body: SupportEmail.Body(
                appName: appInfo.name,
                appVersion: appInfo.version,
                deviceName: appInfo.device,
                systemInfo: appInfo.system
            ),
            recipient: buildConfiguration.supportEmailAddress(),
            subject: "[Bug] \(appInfo.name)"
        )
        bugEmail.send(openURL: openURL)
    }

    func shareURL() -> URL {
        guard let url = appURL else { fatalError() }
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
