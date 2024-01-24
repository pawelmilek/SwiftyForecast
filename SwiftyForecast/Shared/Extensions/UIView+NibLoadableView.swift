import UIKit

protocol NibLoadableView: AnyObject {}

extension UIView: NibLoadableView { }

// MARK: - nibName
extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }

}
