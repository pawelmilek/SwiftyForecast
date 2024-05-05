//
//  SupportEmail.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import SwiftUI

@MainActor
final class SupportEmail {
    private let bundle: Bundle
    private let recipient: String
    private let subject: String

    init(bundle: Bundle, recipient: String, subject: String) {
        self.bundle = bundle
        self.recipient = recipient
        self.subject = subject
    }

    func send(openURL: OpenURLAction) {
        guard let mailToURL else { return }

        openURL(mailToURL) { [weak self] accepted in
            guard let self else { return }
            if !accepted {
                print("Device doesn't support email.\n \(body)")
            }
        }
    }

    private var mailToURL: URL? {
        let replacedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let replacedBody = body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "mailto:\(recipient)?subject=\(replacedSubject)&body=\(replacedBody)"
        let url = URL(string: urlString)
        return url
    }

    private var body: String {
      """
        Application: \(bundle.applicationName)
        Version: \(bundle.versionNumber)
        Build: \(bundle.buildNumber)
        Device: \(UIDevice.current.modelName)
        \(UIDevice.current.systemName): \(UIDevice.current.systemVersion)

        Please provide your feedback below.
        ------------------------------------

      """
    }
}
