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

    // MARK: - CurrentWeatherCard
    struct WeatherCard {
        static let backgroundColor = Color(uiColor: .primary)
        static let cornerRadius: CGFloat = 25
        static let shadowColor = Color(.shadow)
        static let lineBorderWidth = CGFloat(2)
        static let shadowRadius = CGFloat(0)
        static let shadow = (x: CGFloat(2.5), y: CGFloat(2.5))
        static let textColor = Color.white

        static let locationNameFont = Font.system(.title2, design: .monospaced, weight: .semibold)
        static let dayDescriptionFont = Font.system(.footnote, design: .monospaced, weight: .semibold)
        static let temperatureFont = Font.system(size: 80, weight: .black, design: .monospaced)
        static let temperatureMaxMinFont = Font.system(.footnote, design: .monospaced, weight: .black)
        static let conditionsFont = Font.system(.caption, design: .monospaced, weight: .semibold)

        static let iconShadowRadius = CGFloat(0.5)
        static let iconShadowOffset = CGSize(width: 1, height: 1)
        static let iconShadowColor = Color.white
    }

    // MARK: - ConditionView
    struct Condition {
        static let backgroundColor = UIColor.clear
        static let symbolFont = UIFont.TextStyle.caption1
        static let symbolWeight = UIImage.SymbolWeight.semibold
        static let valueFont = UIFont.preferredFont(for: .caption1, weight: .semibold, design: .monospaced)
        static let textColor = UIColor.white
        static let textAlignment = NSTextAlignment.center
    }

    // MARK: - HourlyViewCell
    struct HourlyCell {
        static let backgroundColor = UIColor.primary
        static let cornerRadius = CGFloat(15)
        static let timeFont = UIFont.preferredFont(for: .caption1, weight: .semibold, design: .monospaced)
        static let timeColor = UIColor.tertiary
        static let timeAlignment = NSTextAlignment.center
        static let temperatureFont = UIFont.preferredFont(for: .callout, weight: .bold, design: .monospaced)
        static let temperatureColor = UIColor.tertiary
        static let temperatureAlignment = NSTextAlignment.right
        static let iconContentMode = UIView.ContentMode.scaleAspectFit

        static let lineBorderWidth = CGFloat(2)
        static let shadowRadius = CGFloat(0)
        static let shadowOpacity = Float(1.0)
        static let shadowOffset = CGSize(width: 2.5, height: 2.5)

        static let iconShadowRadius = CGFloat(0.5)
        static let iconShadowOpacity = Float(1.0)
        static let iconShadowOffset = CGSize(width: 1, height: 1)
        static let iconShadowColor = UIColor.white.cgColor
    }

    // MARK: - DailyViewCell
    struct DailyCell {
        static let backgroundColor = UIColor.clear

        static let dateColor = UIColor.tertiary
        static let dateAlignment = NSTextAlignment.left

        static let iconColor = UIColor.tertiary
        static let iconAlignment = NSTextAlignment.center

        static let temperatureFont = UIFont.preferredFont(for: .title3, weight: .bold, design: .monospaced)
        static let temperatureColor = UIColor.tertiary
        static let temperatureAlignment = NSTextAlignment.center

        static let weekdayFont = UIFont.preferredFont(for: .subheadline, weight: .bold, design: .monospaced)
        static let monthFont = UIFont.preferredFont(for: .caption1, weight: .light, design: .monospaced)

        static let iconShadowRadius = CGFloat(0.5)
        static let iconShadowOpacity = Float(1.0)
        static let iconShadowOffset = CGSize(width: 1, height: 1)
    }

    // MARK: - LocationRow
    struct LocationRow {
        static let backgroundColor = UIColor.clear
        static let timeFont = Font.system(.subheadline, design: .monospaced, weight: .semibold)
        static let timeColor = Color(uiColor: .primary)
        static let timeAlignment = NSTextAlignment.left

        static let nameFont = Font.system(.subheadline, design: .monospaced, weight: .semibold)
        static let nameColor = Color(uiColor: .tertiary)
        static let locationNameAlignment = NSTextAlignment.left

        static let cornerRadius = CGFloat(15)
        static let borderColor = Color(uiColor: .shadow)
        static let shadowColor = Color(uiColor: .shadow)
        static let lineBorderWidth = CGFloat(2)
        static let shadowRadius = CGFloat(0)
        static let shadowOpacity = Float(1.0)
        static let shadowOffset = (x: 2.5, y: 2.5)

        static let separatorColor = UIColor.secondary.withAlphaComponent(0.8)
    }

    // MARK: - LocationSearchResultRow
    struct LocationSearchResultRow {
        static let fontDesign = Font.Design.monospaced
        static let titleFont = Font.callout
        static let subtitleFont = Font.subheadline
        static let titleFontWeight = Font.Weight.regular
        static let subtitleFontWeight = Font.Weight.bold
    }

    // MARK: - OfflineViewController
    struct Offline {
        static let backgroundColor = UIColor.systemBackground
        static let symbolFont = UIFont.systemFont(ofSize: 100, weight: .light)
        static let symbolColor = UIColor.tertiary
        static let descriptionFont = UIFont.preferredFont(for: .title2, weight: .bold, design: .monospaced)
        static let descriptionColor = UIColor.tertiary
        static let descriptionAlignment = NSTextAlignment.center
    }
}
