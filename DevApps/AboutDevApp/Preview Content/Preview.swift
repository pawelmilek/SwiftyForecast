//
//  Preview.swift
//  AboutDevApp
//
//  Created by Pawel Milek on 7/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import AboutFeatureUI
import AboutFeatureDomain
import AboutFeatureData

@MainActor
enum Preview {
    static var viewModel: AboutViewModel {
        AboutViewModel(
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
                        )
                    ),
                    decoder: JSONDecoder()
                )
            ),
            deviceService: UserDeviceService(
                repository: ReleasedDevicesRepository(
                    dataSource: LocalDevicesDataSource(),
                    decoder: JSONDecoder()
                )
            ),
            licenseService: PackagesLicenseService(
                repository: PackagesLicenseRepository(
                    dataSource: LocalLicenseDataSource(
                        licenseFile: LocalFileResource(
                            name: "packages_license",
                            fileExtension: "html",
                            bundle: .main
                        )
                    )
                )
            )
        )
    }
}
