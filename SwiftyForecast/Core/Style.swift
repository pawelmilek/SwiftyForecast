import UIKit
import SwiftUI

struct Style {
    // MARK: - NavigationBar
    struct NavigationBar {
        static let barButtonItemColor = UIColor.tertiary
        static let titleColor = UIColor.tertiary
    }

    // MARK: - MainViewController
    struct Main {
        static let segmentedControlFont = UIFont.preferredFont(for: .body, weight: .bold, design: .rounded)
        static let segmentedControlBorderWidth: CGFloat = 1.0
        static let segmentedControlSelectedLabelColor = UIColor.secondary

        static let segmentedControlUnselectedLabelColor = UIColor.tertiary
        static let segmentedControlBorderColor = UIColor.tertiary
        static let segmentedControlThumbColor = UIColor.tertiary
        static let segmentedControlBackgroundColor = UIColor.clear

        static let pageIndicatorTintColor = UIColor.tertiary
        static let currentPageIndicatorColor = UIColor.primary
        static let backgroundColor = UIColor.systemBackground
    }

    // MARK: - WeatherViewController
    struct Weather {
        static let tableViewBackgroundColor = UIColor.clear
        static let tableViewSeparatorStyle = UITableViewCell.SeparatorStyle.none
        static let backgroundColor = UIColor.systemBackground
    }

    // MARK: - CurrentWeatherView
    struct Current {
        static let backgroundColor = UIColor.clear
        static let shadowColor = UIColor.primary.cgColor
        static let shadowOffset = CGSize(width: 0, height: 5)
        static let shadowOpacity: Float = 0.5
        static let shadowRadius: CGFloat = 10.0
        static let cornerRadius: CGFloat = 15.0

        static let textColor = UIColor.secondary
        static let textAlignment = NSTextAlignment.center

        static let dateFont = UIFont.preferredFont(for: .headline, weight: .heavy, design: .rounded)
        static let cityNameFont = UIFont.preferredFont(for: .callout, weight: .regular, design: .rounded)
        static let temperatureFont = UIFont.preferredFont(with: 90, weight: .bold, design: .rounded)
        static let conditionDescriptionFont = UIFont.preferredFont(for: .footnote, weight: .bold, design: .rounded)
        static let subTemperatureFont = UIFont.preferredFont(for: .footnote, weight: .bold, design: .rounded)
    }

    // MARK: - ConditionView
    struct Condition {
        static let backgroundColor = UIColor.clear
        static let symbolFont = UIFont.TextStyle.caption2
        static let symbolWeight = UIImage.SymbolWeight.regular
        static let valueFont = UIFont.preferredFont(for: .caption2, weight: .regular, design: .rounded)
        static let textColor = UIColor.secondary
        static let textAlignment = NSTextAlignment.center
    }

    // MARK: - DailyTableViewCell
    struct DailyCell {
        static let backgroundColor = UIColor.clear

        static let dateColor = UIColor.tertiary
        static let dateAlignment = NSTextAlignment.left

        static let iconColor = UIColor.tertiary
        static let iconAlignment = NSTextAlignment.center

        static let temperatureFont = UIFont.preferredFont(for: .body, weight: .bold, design: .rounded)
        static let temperatureColor = UIColor.tertiary
        static let temperatureAlignment = NSTextAlignment.center

        static let weekdayFont = UIFont.preferredFont(for: .caption2, weight: .bold, design: .rounded)
        static let monthFont = UIFont.preferredFont(for: .caption2, weight: .regular, design: .rounded)
    }

    // MARK: - HourlyForecastCollectionViewCell
    struct HourlyCell {
        static let backgroundColor = UIColor.clear

        static let timeFont = UIFont.preferredFont(for: .caption2, weight: .bold, design: .rounded)
        static let timeColor = UIColor.secondary
        static let timeAlignment = NSTextAlignment.center

        static let temperatureFont = UIFont.preferredFont(for: .caption2, weight: .bold, design: .rounded)
        static let temperatureColor = UIColor.secondary
        static let temperatureAlignment = NSTextAlignment.center
    }

    // MARK: - LocationList
    struct LocationList {
        static let searchLocationButtonBackgroundColor = UIColor.primary
        static let searchLocationButtonFont = UIFont.preferredFont(for: .body, weight: .bold, design: .rounded)
        static let backgroundColor = UIColor.clear
        static let separatorColor = UIColor.lightGray
        static let separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        static let separatorInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
    }

    // MARK: - LocationRowView
    struct LocationListRow {
        static let backgroundColor = UIColor.clear
        static let timeFont = UIFont.preferredFont(for: .subheadline, weight: .bold, design: .rounded)
        static let timeColor = UIColor.primary
        static let timeAlignment = NSTextAlignment.left

        static let locationNameFont = UIFont.preferredFont(for: .headline, weight: .bold, design: .rounded)
        static let locationNameColor = UIColor.tertiary
        static let locationNameAlignment = NSTextAlignment.left

        static let separatorColor = UIColor.secondary.withAlphaComponent(0.8)
        static let cornerRadius = CGFloat(15)
    }

    // MARK: - OfflineViewController
    struct Offline {
        static let backgroundColor = UIColor.systemBackground
        static let descriptionFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        static let descriptionColor = UIColor.tertiary
        static let descriptionAlignment = NSTextAlignment.center
    }

    // MARK: ActivityIndicatorView
    struct ActivityIndicator {
        static let indicatorColor = UIColor.secondary
    }

    // MARK: AnnotationView
    struct Annotation {
        static let backgroundColor = Color.white
        static let cornerRadius = CGFloat(15)
        static let fontDesign = Font.Design.rounded

        static let titleFont = Font.callout
        static let titleFontWeight = Font.Weight.bold
        static let titleColor = Color(UIColor.tertiary)

        static let subtitleFont = Font.footnote
        static let subtitleColor = Color.secondary

        static let timeFont = Font.caption
        static let timeFontWeight = Font.Weight.bold
        static let timeColor = Color(UIColor.primary)

        static let systemSymbolColor = Color(UIColor.primary)
    }
}
