import UIKit

extension UITableView {
  
  func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
    beginUpdates()
    deleteRows(at: deletions.map(IndexPath.fromRow), with: .fade)
    insertRows(at: insertions.map(IndexPath.fromRow), with: .fade)
    reloadRows(at: updates.map(IndexPath.fromRow), with: .none)
    endUpdates()
  }

}

extension IndexPath {

  static func fromRow(_ row: Int) -> IndexPath {
    return IndexPath(row: row, section: 0)
  }

}
