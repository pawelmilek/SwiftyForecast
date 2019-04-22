//  Created by Pawel Milek on 11/08/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//
import Foundation
import UIKit

final class ActivityIndicatorView {
  static let shared = ActivityIndicatorView()

  private lazy var activityIndicator: NVActivityIndicatorView = {
    let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    let indicator = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple, color: UIColor.orange.withAlphaComponent(0.6))
    return indicator
  }()
  
  private var containerView = UIView()
  private var view: UIView? {
    didSet {
      guard let view = view else { return }
      containerView.backgroundColor = UIColor.clear
      containerView.addSubview(activityIndicator)
      view.addSubview(containerView)
      
      containerView.translatesAutoresizingMaskIntoConstraints = false
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
      activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
      activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
  }
  
  private init() {}
}


// MARK: - Start/Stop indicator
extension ActivityIndicatorView {
  
  func startAnimating(at view: UIView) {
    DispatchQueue.main.async {
      self.view = view
      self.activityIndicator.startAnimating()
    }
  }
  
  
  func stopAnimating() {
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      self.containerView.removeFromSuperview()
    }
  }
  
}
