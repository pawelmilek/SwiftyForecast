//
//  StoryboardIdentifiable.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/08/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
  
}
