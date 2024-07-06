//
//  ThemeTipToolbarAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import AboutFeatureUI

struct ThemeTipToolbarAdapter: ToolbarInteractive {
    func doneItemTapped() {
        Task(priority: .userInitiated) {
            await ThemeTip.didTipBecomePresentableEvent.donate()
        }
    }
}
