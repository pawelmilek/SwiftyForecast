import UIKit

protocol Registrable: AnyObject {}

// MARK: - Register table cell
extension Registrable where Self: UITableView {
  
  func register<T: UITableViewCell>(cellClass: T.Type) {
    let nib = UINib(nibName:  T.nibName, bundle: nil)
    register(nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
}

// MARK: - Register collection cell
extension Registrable where Self: UICollectionView {
  
  func register<T: UICollectionViewCell>(cellClass: T.Type) {
    let nib = UINib(nibName:  T.nibName, bundle: nil)
    register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
}
