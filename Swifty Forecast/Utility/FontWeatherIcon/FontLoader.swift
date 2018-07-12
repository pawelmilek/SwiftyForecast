//
//  FontLoader.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit
import CoreText

class FontLoader {
  static let shared = FontLoader()
  
  func loadFont(with name: String) throws {
    guard let path = Bundle.main.path(forResource: name, ofType: "ttf") else {
      throw FontWeatherIconError.fileNotFound(name: name)
    }
    
    
    let fontURL = URL(fileURLWithPath: path)
    var error: Unmanaged<CFError>?
    
    if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process ,&error) {
      let errorDescription = CFErrorCopyDescription(error!.takeUnretainedValue()) as String
      let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
      NSException(name: .internalInconsistencyException, reason: errorDescription , userInfo: [NSUnderlyingErrorKey: nsError]).raise()
    }
    
  }
}
