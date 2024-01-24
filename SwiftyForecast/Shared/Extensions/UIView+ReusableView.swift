//
//  UIView+ReusableView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit

protocol ReusableView: AnyObject { }

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return "id\(self)"
    }
}

extension UIView: ReusableView { }
