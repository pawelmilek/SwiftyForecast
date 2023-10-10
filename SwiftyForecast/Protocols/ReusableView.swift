import UIKit

protocol ReusableView: AnyObject {}

// MARK: - Reuse identifier
extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return "id\(self)"
    }

}
