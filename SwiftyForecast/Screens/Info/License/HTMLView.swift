//
//  HTMLView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/25/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    private let fileURL: URL?

    init(fileURL: URL?) {
        self.fileURL = fileURL
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let fileURL else { return }
        uiView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
    }
}
