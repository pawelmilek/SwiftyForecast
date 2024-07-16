//
//  OfflineViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit

final class OfflineViewController: UIViewController {
    private struct Style {
        static let backgroundColor = UIColor.systemBackground
        static let symbolFont = UIFont.systemFont(ofSize: 100, weight: .light)
        static let symbolColor = UIColor.accent
        static let descriptionFont = UIFont.preferredFont(for: .title2, weight: .bold, design: .monospaced)
        static let descriptionColor = UIColor.accent
        static let descriptionAlignment = NSTextAlignment.center
    }
    static let identifier = 0xDEADBEEF

    private var centerImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(
            font: Style.symbolFont,
            scale: .large
        )
        imageView.image = UIImage(systemName: "wifi.slash", withConfiguration: config)
        imageView.tintColor = Style.symbolColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("You are offline", comment: "")
        label.font = Style.descriptionFont
        label.textColor = Style.descriptionColor
        label.textAlignment = Style.descriptionAlignment
        label.numberOfLines = 1
        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()

    override func loadView() {
        super.loadView()
        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Private - Setups
private extension OfflineViewController {

    func setup() {
        self.view.tag = OfflineViewController.identifier
        view.backgroundColor = Style.backgroundColor
    }

    func setupLayout() {
        stackView.addArrangedSubview(centerImageView)
        stackView.addArrangedSubview(descriptionLabel)
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
    }
}

#Preview {
    OfflineViewController()
}
