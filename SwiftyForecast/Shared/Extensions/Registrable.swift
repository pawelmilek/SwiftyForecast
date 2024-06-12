//
//  Registrable.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit

protocol Registrable: AnyObject {}

extension Registrable where Self: UICollectionView {
    @MainActor
    func register<T: UICollectionViewCell>(cellClass: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

extension Registrable where Self: UITableView {
    @MainActor
    func register<T: UITableViewCell>(cellClass: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView: Registrable {}
extension UITableView: Registrable {}
