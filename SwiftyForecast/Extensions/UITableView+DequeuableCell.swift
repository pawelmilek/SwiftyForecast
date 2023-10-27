import UIKit

protocol DequeuableCell: AnyObject {}

extension UITableView: DequeuableCell { }

// MARK: - Dequeue Cell
extension DequeuableCell where Self: UITableView {

  func dequeueCell<T: UITableViewCell>(_ ofType: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }

    return cell
  }

}
