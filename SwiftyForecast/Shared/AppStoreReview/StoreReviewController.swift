//
//  StoreReviewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import StoreKit

struct StoreReviewController: StoreReview {
    private let connectedScenes: Set<UIScene>

    init(connectedScenes: Set<UIScene>) {
        self.connectedScenes = connectedScenes
    }

    func request() {
        if let scene = connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
