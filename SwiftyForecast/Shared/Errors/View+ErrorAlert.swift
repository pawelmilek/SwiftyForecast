//
//  View+ErrorAlert.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
