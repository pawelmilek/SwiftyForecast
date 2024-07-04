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
    struct Body {
        let appName: String
        let appVersion: String
        let deviceName: String
        let systemInfo: String
    }

    private let body: Body
    private let recipient: String
    private let subject: String

    init(body: Body, recipient: String, subject: String) {
        self.body = body
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
        let replacedBody = bodyContent.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "mailto:\(recipient)?subject=\(replacedSubject)&body=\(replacedBody)"
        let url = URL(string: urlString)
        return url
    }

    private var bodyContent: String {
      """
        Application: \(body.appName)
        Version: "\(body.appVersion)"
        Device: \(body.deviceName)
        \(body.systemInfo)

        Please provide your feedback below.
        ------------------------------------

      """
    }
}
