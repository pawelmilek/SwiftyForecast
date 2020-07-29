import UIKit

struct Style {
  static let degreeSign = "\u{00B0}"
  static let fahrenheitDegree = "\(Style.degreeSign)F"
  static let celsiusDegree = "\(Style.degreeSign)C"
  
  // MARK: - NavigationBar
  struct NavigationBar {
    static let barButtonItemColor = UIColor.blackShade
    static let titleTextColor = UIColor.blackShade
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
    
    static let iconLabelTextColor = UIColor.white
    
    static var cityNameLabelFont: UIFont? {
      if UIScreen.PhoneModel.isPhoneSE {
        return UIFont(name:  "HelveticaNeue-Light", size: 15)
      } else {
        return UIFont(name:  "HelveticaNeue-Light", size: 20)
      }
    }
    
    static let cityNameLabelTextColor = UIColor.blackShade
    static let cityNameLabelTextAlignment = NSTextAlignment.left
    static let cityNameLabelNumberOfLines = 1
    
    static var conditionSummaryLabelFont: UIFont? {
      if UIScreen.PhoneModel.isPhoneSE {
        return UIFont(name:  "HelveticaNeue-Medium", size: 11)
      } else {
        return UIFont(name:  "HelveticaNeue-Medium", size: 13)
      }
    }
    
    static let conditionSummaryLabelTextColor = UIColor.blackShade
    static let conditionSummaryLabelTextAlignment = NSTextAlignment.left
    static let conditionSummaryLabelNumberOfLines = 2
    
    static var humidityLabelFont: UIFont? {
      if UIScreen.PhoneModel.isPhoneSE {
        return UIFont(name:  "HelveticaNeue-Medium", size: 11)
      } else {
        return UIFont(name:  "HelveticaNeue-Medium", size: 13)
      }
    }
    
    static let humidityLabelTextColor = UIColor.blackShade
    static let humidityLabelTextAlignment = NSTextAlignment.left
    static let humidityLabelNumberOfLines = 1
    
    static let temperatureLabelFont = UIFont(name:  "HelveticaNeue-Light", size: 57)
    static let temperatureLabelTextColor = UIColor.blackShade
    static let temperatureLabelTextAlignment = NSTextAlignment.left
    static let temperatureLabelNumberOfLines = 1
    
    static let temperatureMaxMinLabelFont = UIFont(name:  "HelveticaNeue-Light", size: 20)
    static let temperatureMaxMinLabelTextColor = UIColor.blackShade
    static let temperatureMaxMinLabelTextAlignment = NSTextAlignment.left
    static let temperatureMaxMinLabelNumberOfLines = 1
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
    static let dateLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 15)
    static let cityNameLabelFont = UIFont(name: "HelveticaNeue-Light", size: 12)
    static let temperatureLabelFont = UIFont(name: "HelveticaNeue-Light", size: 90)
  }
  
  // MARK: - ConditionView
  struct Condition {
    static let backgroundColor = UIColor.white.withAlphaComponent(0.3)
    static let cornerRadius: CGFloat = 5.0
    static let valueLabelFont = UIFont(name: "HelveticaNeue", size: 11)
    static let textColor = UIColor.white
    static let textAlignment = NSTextAlignment.center
    static let conditionFontSize = CGFloat(20)
  }
  
  // MARK: - CityTableViewCell
  struct CityCell {
    static let backgroundColor = UIColor.clear
    static let currentTimeLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 15)
    static let currentTimeLabelTextColor = UIColor.orange.withAlphaComponent(0.8)
    static let currentTimeLabelTextAlignment = NSTextAlignment.left
    
    static let cityNameLabelFont = UIFont(name: "HelveticaNeue-Light", size: 19)
    static let cityNameLabelTextColor = UIColor.blackShade
    static let cityNameLabelTextAlignment = NSTextAlignment.left
    
    static let separatorColor = UIColor.white.withAlphaComponent(0.8)
  }
  
  // MARK: - DailyForecastTableViewCell
  struct DailyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let dateLabelTextColor = UIColor.blackShade
    static let dateLabelTextAlignment = NSTextAlignment.left
    
    static let iconLabelTextColor = UIColor.blackShade
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont(name: "HelveticaNeue-Light", size: 17)
    static let temperatureLabelTextColor = UIColor.blackShade
    static let temperatureLabelTextAlignment = NSTextAlignment.center
    
    static let weekdayLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 11)!
    static let monthLabelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
    
    static let conditionIconSize: CGFloat = 22
  }
  
  // MARK: - HourlyForecastCollectionViewCell
  struct HourlyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let timeLabelFont = UIFont(name: "HelveticaNeue-Light", size: 11)
    static let timeLabelTextColor = UIColor.white
    static let timeLabelTextAlignment = NSTextAlignment.center
    
    static let iconLabelTextColor = UIColor.white
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 13)
    static let temperatureLabelTextColor = UIColor.white
    static let temperatureLabelTextAlignment = NSTextAlignment.center
    
    static let conditionIconSize: CGFloat = 25
  }
  
  // MARK: - CitySelection
  struct CitySelection {
    static let backgroundColor = UIColor.clear
    static let separatorColor = UIColor.blackShade
  }
  
  // MARK: - LocationSearch
  struct LocationSearch {
    static let primaryTextColor = UIColor.orange
    static let primaryTextHighlightColor = UIColor.orange.withAlphaComponent(0.6)
    static let secondaryTextColor = UIColor.blackShade

    static let searchTextColorInSearchBar = UIColor.orange
    static let searchTextFontInSearchBar = UIFont.systemFont(ofSize: 14, weight: .light)
    static let searchTextFieldColorPlaceholder = UIColor.blackShade.withAlphaComponent(0.6)
    static let searchTextFieldFontPlaceholder = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let searchBarCancelButtonColor = UIColor.orange
    static let searchBarCancelButtonFont = UIFont.systemFont(ofSize: 14, weight: .regular)

    static let separatorColor = UIColor.blackShade.withAlphaComponent(0.7)
    static let backgroundColor = UIColor.clear
  }
  
  // MARK: - ForecastContentViewController
  struct ForecastContentVC {
    static let tableViewBackgroundColor = UIColor.white
    static let tableViewSeparatorStyle = UITableViewCell.SeparatorStyle.none
  }
  
  // MARK: - ForecastMainViewController
  struct ForecastMainVC {
    static let measuringSystemSegmentedControlFont = UIFont(name: "HelveticaNeue-Medium", size: 14)
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
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let descriptionLabelTextColor = UIColor.blackShade
    static let descriptionLabelTextAlignment = NSTextAlignment.center
  }
  
  // MARK: - CitySearchBar
  struct CitySearchBar {
    static let backgroundColor = UIColor.ecstasy
    static let cancelButtonFont = UIFont(name: "AvenirNext-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
    static let cancelButtonColor = UIColor.white
    static let cancelButtonBackgroundColor = UIColor.white
    
    static let searchTextFieldBackgroundColor = UIColor.white
    static let searchTextFieldFont = UIFont(name: "AvenirNext-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
    static let searchTextFieldColor = UIColor.black
    static let searchTextFieldPlaceholder = UIColor.gray
    static var searchTextFieldTintColor = UIColor.ecstasy
    static let textFieldClearButtonColor = UIColor.gray
    static let glassIconColor = UIColor.gray
  }
  
  // MARK: ActivityIndicatorView
  struct ActivityIndicator {
    static let indicatorColor = UIColor.white
  }
}
