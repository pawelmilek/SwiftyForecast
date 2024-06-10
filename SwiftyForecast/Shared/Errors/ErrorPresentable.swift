//
//  ErrorPresentable.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol ErrorPresentable: LocalizedError { }

// MARK: - Present errors
extension ErrorPresentable {

  func present() {
    DispatchQueue.main.async {
        AlertViewPresenter.shared.presentError(
            withMessage: self.errorDescription ?? InvalidReference.undefined
        )
    }
  }

}
