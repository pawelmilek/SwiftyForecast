//
//  LottieAnimationViewController.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

class LottieAnimationViewController: UIViewController {
    static let identifier = 0xDEADAEEE

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.view.tag = Self.identifier
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let lottieAnimationView = LottieAnimationView()
        let hostingViewController = UIHostingController(rootView: lottieAnimationView)
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(hostingViewController)

        NSLayoutConstraint.activate([
            hostingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }
}

#Preview {
    LottieAnimationViewController()
}
