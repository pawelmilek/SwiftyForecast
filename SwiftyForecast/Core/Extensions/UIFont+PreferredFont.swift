//
//  UIFont+PreferredFont.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/13/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit

extension UIFont {

    static func preferredFont(
        for style: TextStyle,
        weight: Weight,
        design: UIFontDescriptor.SystemDesign = .default
    ) -> UIFont {
        // Get the style's default pointSize
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traits)

        // Get the font at the default size and preferred weight
        var font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        font = font.with(design)

        // Setup the font to be auto-scalable
        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }

    static func preferredFont(
        with size: CGFloat,
        weight: Weight,
        design: UIFontDescriptor.SystemDesign = .default
    ) -> UIFont {
        // Get the style's default pointSize
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body, compatibleWith: traits)
            .withSize(size)

        // Get the font at the default size and preferred weight
        var font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        font = font.with(design)

        // Setup the font to be auto-scalable
        let metrics = UIFontMetrics(forTextStyle: .body)
        return metrics.scaledFont(for: font)
    }

    private func with(_ design: UIFontDescriptor.SystemDesign) -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(design) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
