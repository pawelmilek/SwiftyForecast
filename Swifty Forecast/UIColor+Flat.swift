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

import UIKit


extension UIColor {
    
    class func shakespeare() -> UIColor {
        return UIColor.colorRGB(component: (82, 179, 217))
    }
    
    
    class func spray() -> UIColor {
        return UIColor.colorRGB(component: (129, 207, 224))
    }
    
    
    class func ecstasy() -> UIColor {
        return UIColor.colorRGB(component: (249, 105, 14))
    }
    
}


fileprivate extension UIColor {
    
    class func colorRGB(component: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        return UIColor(red: component.0/255, green: component.1/255, blue: component.2/255, alpha: 1)
    }
    
}
