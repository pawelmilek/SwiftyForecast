import Foundation

protocol ErrorHandleable: Error, CustomStringConvertible { }

// MARK: - Handle errors
extension ErrorHandleable {
  
  func handle() {
    DispatchQueue.main.async {
      AlertViewPresenter.shared.presentError(withMessage: self.description)
    }
  }
  
}
