//
//  Style.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 28/09/18.
//  Copyright © 2016 imac. All rights reserved.
//

import Foundation
import UIKit

struct Style {
  // MARK: - NavigationBar
  struct NavigationBar {
    static let barButtonItemColor = UIColor.blackShade
    static let titleTextColor = UIColor.blackShade
  }
  
  
  // MARK: - CurrentForecastView
  struct CurrentForecast {
    static let backgroundColor = UIColor.clear
    static let shadowColor = UIColor.red.cgColor
    static let shadowOffset = CGSize(width: 0, height: 5)
    static let shadowOpacity: Float = 0.5
    static let shadowRadius: CGFloat = 10.0
    static let cornerRadius: CGFloat = 15.0
    
    static var conditionFontIconSize: CGFloat {
      if UIScreen.PhoneModel.isPhoneSE {
        return 70
        
      } else if UIScreen.PhoneModel.isPhone8 {
        return 100
        
      } else {
        return 130
      }
    }
    
    static let textColor = UIColor.white
    static let textAlignment = NSTextAlignment.center
    static let dateLabelFont = UIFont.systemFont(ofSize: 15, weight: .heavy)
    static let cityNameLabelFont = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
    static let temperatureLabelFont = UIFont.systemFont(ofSize: 90, weight: .bold)
  }
  
  
  // MARK: - ConditionView
  struct Condition {
    static let backgroundColor = UIColor.white.withAlphaComponent(0.3)
    static let cornerRadius: CGFloat = 5.0
    static let valueLabelFont = UIFont.systemFont(ofSize: 11, weight: .bold)
    static let textColor = UIColor.white
    static let textAlignment = NSTextAlignment.center
  }
  
  
  // MARK: - CityTableViewCell
  struct CityCell {
    static let backgroundColor = UIColor.clear
    static let currentTimeLabelFont = UIFont.systemFont(ofSize: 17, weight: .medium)
    static let currentTimeLabelTextColor = UIColor.blackShade
    static let currentTimeLabelTextAlignment = NSTextAlignment.left
    
    static let cityNameLabelFont = UIFont.systemFont(ofSize: 22, weight: .regular)
    static let cityNameLabelTextColor = UIColor.white
    static let cityNameLabelTextAlignment = NSTextAlignment.left
  }
  
  
  // MARK: - DailyForecastTableViewCell
  struct DailyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let dateLabelTextColor = UIColor.blackShade
    static let dateLabelTextAlignment = NSTextAlignment.left
    
    static let iconLabelTextColor = UIColor.blackShade
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let temperatureLabelTextColor = UIColor.blackShade
    static let temperatureLabelTextAlignment = NSTextAlignment.center
  }
  
  // MARK: - HourlyForecastCollectionViewCell
  struct HourlyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let timeLabelFont = UIFont.systemFont(ofSize: 11, weight: .light)
    static let timeLabelTextColor = UIColor.white
    static let timeLabelTextAlignment = NSTextAlignment.center
    
    static let iconLabelTextColor = UIColor.white
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont.systemFont(ofSize: 11, weight: .bold)
    static let temperatureLabelTextColor = UIColor.white
    static let temperatureLabelTextAlignment = NSTextAlignment.center
  }
  
  
  // MARK: - ForecastCityListTableViewController
  struct ForecastCityListVC {
    static let autocompleteVCPrimaryTextColor = UIColor.orange
    static let autocompleteVCPrimaryTextHighlightColor = UIColor.orange.withAlphaComponent(0.6)
    static let autocompleteVCSecondaryTextColor = UIColor.blackShade
    static let autocompleteVCTableCellSeparatorColor = UIColor.blackShade.withAlphaComponent(0.7)
    static let autocompleteVCSSearchTextColorInSearchBar = UIColor.orange
    static let autocompleteVCSSearchTextFontInSearchBar = UIFont.systemFont(ofSize: 14, weight: .light)
    static let autocompleteVCSearchTextFieldColorPlaceholder = UIColor.blackShade.withAlphaComponent(0.6)
    static let autocompleteVCSearchTextFieldFontPlaceholder = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let autocompleteVCSearchBarCancelButtonColor = UIColor.orange
    static let autocompleteVCSearchBarCancelButtonFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    static let tableViewSeparatorColor = UIColor.white
    static let tableViewBackgroundColor = UIColor.clear
  }
  
  
  // MARK: - ForecastContentViewController
  struct ForecastContentVC {
    static let tableViewBackgroundColor = UIColor.white
    static let tableViewSeparatorStyle = UITableViewCell.SeparatorStyle.none
  }
  
  
  // MARK: - ForecastMainViewController
  struct ForecastMainVC {
    static let measuringSystemSegmentedControlFont = UIFont(name: "AvenirNext-Bold", size: 14)
    static let measuringSystemSegmentedControlBorderWidth: CGFloat = 1.0
    static let measuringSystemSegmentedControlSelectedLabelColor = UIColor.white
    
    static let measuringSystemSegmentedControlUnselectedLabelColor = UIColor.blackShade
    static let measuringSystemSegmentedControlBorderColor = UIColor.blackShade
    static let measuringSystemSegmentedControlThumbColor = UIColor.blackShade
    static let measuringSystemSegmentedControlBackgroundColor = UIColor.clear
  }
  
  
  // MARK: - OfflineViewController
  struct OfflineVC {
    static let backgroundColor = UIColor.white
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let descriptionLabelTextColor = UIColor.blackShade
    static let descriptionLabelTextAlignment = NSTextAlignment.left
  }
  
  
  // MARK: - CitySearchBar
  struct CitySearchBar {
    static let backgroundColor = UIColor.ecstasy
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
  
}
