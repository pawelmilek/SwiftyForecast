//
//  LottieAnimationView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieAnimationView: View {
    var body: some View {
        ZStack {
            LottieView(animation: .named("lottie_location_animation"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
        }
    }
}

#Preview {
    LottieAnimationView()
}
