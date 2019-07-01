import Foundation

protocol ErrorHandleable: Error, CustomStringConvertible { }

// MARK: - Handle errors
extension ErrorHandleable {
  
  func handler() {
    DispatchQueue.main.async {
      AlertViewPresenter.presentError(withMessage: self.description)
    }
  }
  
}
