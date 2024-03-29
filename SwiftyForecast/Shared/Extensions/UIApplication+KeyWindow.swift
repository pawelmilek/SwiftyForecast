//
//  UIApplication+KeyWindow.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/25/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit

extension UIApplication {

    var keyWindow: UIWindow? {
        // Get connected scenes
        return self.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }

}
