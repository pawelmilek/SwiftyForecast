import UIKit
import CoreText

class FontLoader {
  
  static func loadFont(with name: String) throws {
    guard let path = Bundle.main.path(forResource: name, ofType: "ttf") else {
      throw FontWeatherIconError.fileNotFound(name: name)
    }
    
    let fontURL = URL(fileURLWithPath: path)
    var error: Unmanaged<CFError>?
    
    if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
      guard let error = error else { throw FontWeatherIconError.fontRegistrationFailed }
      guard let nsError = error.takeUnretainedValue() as AnyObject as? NSError else { throw FontWeatherIconError.fontRegistrationFailed }
      
      let errorDescription = CFErrorCopyDescription(error.takeUnretainedValue()) as String
      NSException(name: .internalInconsistencyException,
                  reason: errorDescription,
                  userInfo: [NSUnderlyingErrorKey: nsError]).raise()
    }
    
  }
}
