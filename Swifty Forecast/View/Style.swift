//
//  Style.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 imac. All rights reserved.
//

import Foundation
import UIKit

struct Style {
  
  // MARK: - NavigationBar
  struct NavigationBar {
    static let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .bold)
    static let tintColor = UIColor.white
    static let backgroundColor = UIColor.ecstasy
  }
  
  
  // MARK: - PageControl
  struct PageControl {
    static let backgroundColor = UIColor.ecstasy
    static let tintColor = UIColor.white
  }
  
  
  // MARK: - CitySearchBar
  struct CitySearchBar {
    static var backgroundColor = UIColor.ecstasy
    static let cancelButtonFont = UIFont.init(name: "AvenirNext-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
    static let cancelButtonColor = UIColor.white
    static let cancelButtonBackgroundColor = UIColor.white
    
    static let searchTextFieldBackgroundColor = UIColor.white
    static let searchTextFieldFont = UIFont.init(name: "AvenirNext-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
    static let searchTextFieldColor = UIColor.black
    static let searchTextFieldPlaceholder = UIColor.gray
    static var searchTextFieldTintColor = UIColor.ecstasy
    static let textFieldClearButtonColor = UIColor.gray
    static let glassIconColor = UIColor.gray
  }
  
  
  // MARK: - RestaurantCollectionViewCell
  struct RestaurantCell {
    static let defaultBackgroundColor = UIColor.white
    
    static let restaurantNameLabelFont = UIFont(name: "AvenirNext-DemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    static let restaurantNameLabelTextColor = UIColor.white
    static let restaurantNameLabelAlignment = NSTextAlignment.left
    static let restaurantNameLabelNumberOfLines = 1
    
    static let categoryTypeLabelFont = UIFont(name: "AvenirNext-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
    static let categoryTypeLabelTextColor = UIColor.white
    static let categoryTypeLabelAlignment = NSTextAlignment.left
    static let categoryTypeLabelNumberOfLines = 1
  }
  
  // MARK: RestaurantMapTableViewCell
  struct RestaurantMapCell {
    static let defaultBackgroundColor = UIColor.white
    
    static let nameLabelFont = UIFont(name: "AvenirNext-DemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    static let nameLabelTextColor = UIColor.black
    static let nameLabelAlignment = NSTextAlignment.left
    static let nameLabelNumberOfLines = 1
    
    static let addressLabelFont = UIFont(name: "AvenirNext-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
    static let addressLabelTextColor = UIColor.black
    static let addressLabelAlignment = NSTextAlignment.left
    static let addressLabelNumberOfLines = 1
  }
  
}
