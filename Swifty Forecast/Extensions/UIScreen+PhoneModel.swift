//
//  UIScreen+PhoneModel.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 14/08/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {

  struct PhoneModel {
    private static let size = UIScreen.main.bounds.size
    private static let iPhoneX = CGSize(width: 375, height: 812)
    private static let iPhone8Plus = CGSize(width: 414, height: 736)
    private static let iPhone8 = CGSize(width: 375, height: 667)
    private static let iPhone7Plus = CGSize(width: 414, height: 736)
    private static let iPhone6Plus = CGSize(width: 375, height: 667)
    private static let iPhone6 = CGSize(width: 375, height: 667)
    private static let iPhoneSE = CGSize(width: 320, height: 568)
    
    static var isPhoneX: Bool {
      return size == iPhoneX
    }
    
    static var isPhone8Plus: Bool {
      return size == iPhone8Plus
    }
    
    static var isPhone8: Bool {
      return size == iPhone8
    }
    
    static var isPhone7Plus: Bool {
      return size == iPhone7Plus
    }
    
    static var isPhone6Plus: Bool {
      return size == iPhone6Plus
    }
    
    static var isPhone6: Bool {
      return size == iPhone6
    }
    
    static var isPhoneSE: Bool {
      return size == iPhoneSE
    }
  }
  
}
