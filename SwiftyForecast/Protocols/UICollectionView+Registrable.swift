import UIKit

protocol Registrable: AnyObject { }

extension UICollectionView: Registrable { }

// MARK: - Register collection cell
extension Registrable where Self: UICollectionView {

    func register<T: UICollectionViewCell>(cellClass: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

}
