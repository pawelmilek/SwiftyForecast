//
//  ReusableView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit


protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return "id\(self)"
    }
}
