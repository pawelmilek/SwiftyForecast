import UIKit
import MapKit

struct Style {
  static let degreeSign = "\u{00B0}"
  static let fahrenheitDegree = "\(Style.degreeSign)F"
  static let celsiusDegree = "\(Style.degreeSign)C"
  
  // MARK: - NavigationBar
  struct NavigationBar {
    static let barButtonItemColor = UIColor.primaryThree
    static let titleTextColor = UIColor.primaryThree
  }
  
  // MARK: - WeatherForecastWidget
  struct WeatherWidget {
    static var iconLabelFontSize: CGFloat {
      if UIScreen.PhoneModel.isPhoneSE {
        return CGFloat(50)
      } else {
        return CGFloat(55)
      }
    }
    
    static let iconLabelTextColor = UIColor.primaryTwo
    
    static var cityNameLabelFont: UIFont? {
      if UIScreen.PhoneModel.isPhoneSE {
        return UIFont.systemFont(ofSize: 15, weight: .light)
      } else {
        return UIFont.systemFont(ofSize: 20, weight: .light)
      }
    }
    
    static let cityNameLabelTextColor = UIColor.primaryThree
    static let cityNameLabelTextAlignment = NSTextAlignment.left
    static let cityNameLabelNumberOfLines = 1
    
    static var conditionSummaryLabelFont: UIFont? {
      if UIScreen.PhoneModel.isPhoneSE {
        return UIFont.systemFont(ofSize: 11, weight: .medium)
      } else {
        return UIFont.systemFont(ofSize: 13, weight: .medium)
      }
    }
    
    static let conditionSummaryLabelTextColor = UIColor.primaryThree
    static let conditionSummaryLabelTextAlignment = NSTextAlignment.left
    static let conditionSummaryLabelNumberOfLines = 2
    
    static var humidityLabelFont: UIFont? {
      if UIScreen.PhoneModel.isPhoneSE {
        return UIFont.systemFont(ofSize: 11, weight: .medium)
      } else {
        return UIFont.systemFont(ofSize: 13, weight: .medium)
      }
    }
    
    static let humidityLabelTextColor = UIColor.primaryThree
    static let humidityLabelTextAlignment = NSTextAlignment.left
    static let humidityLabelNumberOfLines = 1
    
    static let temperatureLabelFont = UIFont.systemFont(ofSize: 57, weight: .light)
    static let temperatureLabelTextColor = UIColor.primaryThree
    static let temperatureLabelTextAlignment = NSTextAlignment.left
    static let temperatureLabelNumberOfLines = 1
    
    static let temperatureMaxMinLabelFont = UIFont.systemFont(ofSize: 20, weight: .light)
    static let temperatureMaxMinLabelTextColor = UIColor.primaryThree
    static let temperatureMaxMinLabelTextAlignment = NSTextAlignment.left
    static let temperatureMaxMinLabelNumberOfLines = 1
  }
  
  // MARK: - CurrentForecastView
  struct CurrentForecast {
    static let backgroundColor = UIColor.clear
    static let shadowColor = UIColor.systemRed.cgColor
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
    
    static let textColor = UIColor.primaryTwo
    static let textAlignment = NSTextAlignment.center
    static let dateLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let cityNameLabelFont = UIFont.systemFont(ofSize: 12, weight: .light)
    static let temperatureLabelFont = UIFont.systemFont(ofSize: 90, weight: .light)
  }
  
  // MARK: - ConditionView
  struct Condition {
    static let backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
    static let cornerRadius: CGFloat = 5.0
    static let valueLabelFont = UIFont.systemFont(ofSize: 11, weight: .regular)
    static let textColor = UIColor.primaryTwo
    static let textAlignment = NSTextAlignment.center
    static let conditionFontSize = CGFloat(20)
  }
  
  // MARK: - CityTableViewCell
  struct CityCell {
    static let backgroundColor = UIColor.clear
    static let currentTimeLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let currentTimeLabelTextColor = UIColor.primaryOne
    static let currentTimeLabelTextAlignment = NSTextAlignment.left
    
    static let cityNameLabelFont = UIFont.systemFont(ofSize: 22, weight: .regular)
    static let cityNameLabelTextColor = UIColor.primaryThree
    static let cityNameLabelTextAlignment = NSTextAlignment.left
    
    static let separatorColor = UIColor.primaryTwo.withAlphaComponent(0.8)
  }
  
  // MARK: - DailyForecastTableViewCell
  struct DailyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let dateLabelTextColor = UIColor.primaryThree
    static let dateLabelTextAlignment = NSTextAlignment.left
    
    static let iconLabelTextColor = UIColor.primaryThree
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont.systemFont(ofSize: 17, weight: .light)
    static let temperatureLabelTextColor = UIColor.primaryThree
    static let temperatureLabelTextAlignment = NSTextAlignment.center
    
    static let weekdayLabelFont = UIFont.systemFont(ofSize: 11, weight: .medium)
    static let monthLabelFont = UIFont.systemFont(ofSize: 10, weight: .light)
    
    static let conditionIconSize: CGFloat = 22
  }
  
  // MARK: - HourlyForecastCollectionViewCell
  struct HourlyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let timeLabelFont = UIFont.systemFont(ofSize: 11, weight: .light)
    static let timeLabelTextColor = UIColor.primaryTwo
    static let timeLabelTextAlignment = NSTextAlignment.center
    
    static let iconLabelTextColor = UIColor.primaryTwo
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont.systemFont(ofSize: 13, weight: .medium)
    static let temperatureLabelTextColor = UIColor.primaryTwo
    static let temperatureLabelTextAlignment = NSTextAlignment.center
    
    static let conditionIconSize: CGFloat = 25
  }
  
  // MARK: - CityList
  struct CityList {
    static let searchLocationButtonBackgroundColor = UIColor.primaryOne
    static let backgroundColor = UIColor.clear
    static let separatorColor = UIColor.lightGray
    static let separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    static let separatorInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
  }
  
  // MARK: - LocationSearch
  struct LocationSearch {
    static let primaryTextColor = UIColor.primaryOne
    static let primaryTextHighlightColor = UIColor.primaryOne
    static let secondaryTextColor = UIColor.primaryThree
    
    static let searchTextColorInSearchBar = UIColor.primaryOne
    static let searchTextFontInSearchBar = UIFont.systemFont(ofSize: 14, weight: .light)
    static let searchTextFieldColorPlaceholder = UIColor.primaryThree.withAlphaComponent(0.6)
    static let searchTextFieldFontPlaceholder = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let searchBarCancelButtonColor = UIColor.primaryOne
    static let searchBarCancelButtonFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    static let separatorColor = UIColor.primaryThree.withAlphaComponent(0.7)
    static let backgroundColor = UIColor.secondarySystemBackground
  }
  
  // MARK: - ForecastContentViewController
  struct ContentForecast {
    static let tableViewBackgroundColor = UIColor.clear
    static let tableViewSeparatorStyle = UITableViewCell.SeparatorStyle.none
    static let backgroundColor = UIColor.systemBackground
  }
  
  // MARK: - ForecastMainViewController
  struct MainForecast {
    static let segmentedControlFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let segmentedControlBorderWidth: CGFloat = 1.0
    static let segmentedControlSelectedLabelColor = UIColor.primaryTwo
    
    static let segmentedControlUnselectedLabelColor = UIColor.primaryThree
    static let segmentedControlBorderColor = UIColor.primaryThree
    static let segmentedControlThumbColor = UIColor.primaryThree
    static let segmentedControlBackgroundColor = UIColor.clear
    
    static let currentPageIndicatorColor = UIColor.primaryOne
    static let backgroundColor = UIColor.systemBackground
  }
  
  // MARK: - OfflineViewController
  struct OfflineVC {
    static let backgroundColor = UIColor.systemBackground
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let descriptionLabelTextColor = UIColor.primaryThree
    static let descriptionLabelTextAlignment = NSTextAlignment.center
  }
  
  // MARK: - CitySearchBar
  struct CitySearchBar {
    static let backgroundColor = UIColor.systemGray
    static let searchTextFieldBackgroundColor = UIColor.systemBackground
    static let searchTextFieldFont = UIFont.systemFont(ofSize: 14, weight: .light)
    static let searchTextFieldColor = UIColor.secondaryLabel
    static let searchTextFieldPlaceholder = UIColor.systemGray
    static var searchTextFieldTintColor = UIColor.systemGray
    static let textFieldClearButtonColor = UIColor.systemGray
    static let glassIconColor = UIColor.systemGray
  }
  
  // MARK: ActivityIndicatorView
  struct ActivityIndicator {
    static let indicatorColor = UIColor.primaryTwo
  }
  
  // MARK: AddCalloutView
  struct AddCalloutView {
    static let defaultBackgroundColor = UIColor.secondarySystemBackground
    static let cornerRadius = CGFloat(15)
    static let titleLabelFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    static let titleLabelTextColor = UIColor.primaryOne
    static let titleLabelAlignment = NSTextAlignment.left
    static let titleLabelNumberOfLines = 1
    
    static let subtitleLabelFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let subtitleLabelTextColor = UIColor.secondaryLabel
    static let subtitleLabelAlignment = NSTextAlignment.left
    static let subtitleLabelNumberOfLines = 1
    
    static let addButtonIconName = "ic_add"
    static let addButtonTintColor = UIColor.primaryOne
  }
}
