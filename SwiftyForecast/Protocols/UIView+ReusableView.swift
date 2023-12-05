import UIKit

protocol ReusableView: AnyObject {}

extension UIView: ReusableView { }

// MARK: - Reuse identifier
extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return "id\(self)"
    }

}
