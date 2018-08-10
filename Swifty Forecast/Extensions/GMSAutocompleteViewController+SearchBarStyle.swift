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
    let searchBarTextAttributes = [ NSAttributedString.Key.foregroundColor.rawValue: color, NSAttributedString.Key.font.rawValue: font]
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary(searchBarTextAttributes)
  }
  
  func setSearchTextFieldPlaceholder(color: UIColor, andFont font: UIFont) {
    let placeholderAttributes = [ NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
    
    let attributedPlaceholder = NSAttributedString(string: "Search City", attributes: placeholderAttributes)
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
  }
  
  
  func setSearchBarCancelButton(color: UIColor, andFont font: UIFont) {
    let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
    UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
  }
  
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
