/**
 * Created by Pawel Milek on 27/07/16.
 * Copyright © 2016 imac. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit


protocol Registrable: class {}


extension Registrable where Self: UICollectionView {
    func register<T: UICollectionViewCell where T: ReusableView, T: NibLoadableView>(cellClass: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}


extension Registrable where Self: UITableView {
    func register<T: UITableViewCell where T: ReusableView, T: NibLoadableView>(cellClass: T.Type) {
        let nib = UINib(nibName:  T.nibName, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
}
