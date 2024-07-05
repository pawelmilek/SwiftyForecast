//
//  ContentView.swift
//  AboutDevApp
//
//  Created by Pawel Milek on 7/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import AboutFeatureUI
import AboutFeatureDomain
import AboutFeatureData

struct ContentView: View {
    var body: some View {
        AboutView(
            viewModel: AboutViewModel(
                appInfo: ApplicationInfoAdapter(bundle: .main, currentDevice: .current),
                buildConfiguration: FileBuildConfigurationAdapter(bundle: .main),
                networkResourceFactory: NetworkResourceFactory(),
                analytics: FirebaseAnalyticsAboutAdapter(service: FakeFirebaseAnalyticsService()),
                toolbarInteractive: ThemeTipToolbarAdapter(),
                licenseRepository: HtmlPackageLicenseRepository()
            ),
            tintColor: .customPrimary,
            accentColor: .accent
        )
    }
}

#Preview {
    ContentView()
}

class FakeFirebaseAnalyticsService: AnalyticsService {
    func send(event: AnalyticsEvent) {

    }
}
