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
                appService: NetworkAppService(
                    repository: NetworkAppRepository(
                        dataSource: LocalAppDataSource(
                            localFileResource: LocalFileResource(
                                name: "app_resources",
                                fileExtension: "json",
                                bundle: .main
                            ),
                            decoder: JSONDecoder()
                        )
                    )
                ),
                deviceService: UserDeviceService(
                    repository: ReleasedDevicesRepository(
                        dataSource: LocalReleasedDevicesDataSource(
                            decoder: JSONDecoder()
                        )
                    )
                ),
                licenseService: PackagesLicenseService(
                    repository: PackagesLicenseRepository(
                        dataSource: LocalPackagesLicenseDataSource(
                            licenseFile: LocalFileResource(
                                name: "packages_license",
                                fileExtension: "html",
                                bundle: .main
                            ),
                            bundle: .main
                        )
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
