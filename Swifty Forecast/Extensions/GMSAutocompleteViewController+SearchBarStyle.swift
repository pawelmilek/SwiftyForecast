//
//  GMSAutocompleteViewController+SearchBarStyle.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 25/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

extension GMSAutocompleteViewController {
  
  func setSearchTextInSearchBar(color: UIColor, andFont font: UIFont) {
    let searchBarTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: color, NSAttributedStringKey.font.rawValue: font]
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
  }
  
  func setSearchTextFieldPlaceholder(color: UIColor, andFont font: UIFont) {
    let placeholderAttributes = [ NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font]
    
    let attributedPlaceholder = NSAttributedString(string: "Search City", attributes: placeholderAttributes)
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
  }
  
  
  func setSearchBarCancelButton(color: UIColor, andFont font: UIFont) {
    let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font]
    UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
  }
  
}
