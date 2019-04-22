//
//  OfflineViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 08/09/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
  private let network = NetworkManager.shared
  typealias OfflineStyle = Style.OfflineVC
  
  private var offLineImageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(named: "ic_offline")
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  private var descriptionLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = NSLocalizedString("You are offline, connect to the internet.", comment: "")
    label.font = OfflineStyle.descriptionLabelFont
    label.textColor = OfflineStyle.descriptionLabelTextColor
    label.textAlignment = OfflineStyle.descriptionLabelTextAlignment
    label.numberOfLines = 1
    return label
  }()
  
  private var stackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillProportionally
    stackView.spacing = 0
    return stackView
  }()
  
  override func loadView() {
    super.loadView()
    setupLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
    setupStyle()
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


// MARK: - ViewSetupable protocol
extension OfflineViewController: ViewSetupable {
  
  func setUp() {
    network.whenReachable { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.showMainViewController()
    }
  }
  
  func setupLayout() {
    offLineImageView.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    offLineImageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
    offLineImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
    descriptionLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
    descriptionLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
    
    stackView.addArrangedSubview(offLineImageView)
    stackView.addArrangedSubview(descriptionLabel)
    
    view.addSubview(stackView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
    view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
  }
  
  func setupStyle() {
    view.backgroundColor = OfflineStyle.backgroundColor
  }
  
}


// MARK: - Private - Show Main ViewController
extension OfflineViewController {
  
  private func showMainViewController() -> () {
    DispatchQueue.main.async {
      self.navigationController?.popViewController(animated: false)
    }
  }
  
}
