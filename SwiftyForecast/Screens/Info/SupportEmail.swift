//
//  SupportEmail.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct SupportEmail {
    let recipient: String
    let subject: String
    var body: String {
      """
        Application: \(Bundle.main.applicationName)
        Version: \(Bundle.main.versionNumber)
        Build: \(Bundle.main.buildNumber)
        Device: \(UIDevice.current.modelName)
        iOS: \(UIDevice.current.systemVersion)

        Please provide your feedback below.
        ------------------------------------
      """
    }

    func send(openURL: OpenURLAction) {
        let replacedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let replacedBody = body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "mailto:\(recipient)?subject=\(replacedSubject)&body=\(replacedBody)"

        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("Device doesn't support email.\n \(body)")
            }
        }
    }
}
