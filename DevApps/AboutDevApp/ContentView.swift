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
                appInfo: BundledApplicationInfo(bundle: .main, currentDevice: .current),
                analytics: FirebaseAnalyticsAboutAdapter(
                    service: FakeFirebaseAnalyticsService()
                ),
                toolbarInteractive: ThemeTipToolbarAdapter(),
                networkResourceService: AppNetworkResourceService(
                    repository: AppNetworkResourceRepository(
                        dataSource: LocalNetworkResourceDataSource()
                    )
                ),
                deviceService: UserDeviceService(
                    repository: ReleasedDevicesRepository(
                        dataSource: LocalReleasedDevicesDataSource()
                    )
                ),
                licenseService: PackagesLicenseService(
                    repository: PackageLicenseRepository(
                        dataSource: LocalPackagesLicenseDataSource()
                    )
                )
            ),
            tintColor: .customPrimary,
            accentColor: .accent
        )
    }
}

#Preview {
    ContentView()
}
