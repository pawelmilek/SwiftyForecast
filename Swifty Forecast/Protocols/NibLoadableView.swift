//
//  NibLoadableView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit


protocol NibLoadableView: class {}


extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
