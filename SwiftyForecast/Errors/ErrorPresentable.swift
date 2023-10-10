import Foundation

protocol ErrorPresentable: Error, LocalizedError { }

// MARK: - Present errors
extension ErrorPresentable {

  func present() {
    DispatchQueue.main.async {
        AlertViewPresenter.shared.presentError(withMessage: self.errorDescription ?? InvalidReference.undefined)
    }
  }

}
