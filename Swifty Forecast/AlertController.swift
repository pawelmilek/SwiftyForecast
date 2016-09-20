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
import XLActionController


final class AlertController: UIAlertController {
    private var alertWindow: UIWindow? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.alertWindow?.hidden = true
        self.alertWindow = nil
    }
    
    
    func show() {
        self.show(true)
    }

}



// MARK: Present Error 
extension AlertController {
    class func presentAlertWith(error: NSError) {
        let title = "Error"
        let message = error.localizedDescription
        
        AlertController.presentAlertWith(title, andMessage: message)
    }
    
    
    class func presentAlertWith(errorMessage errorMsg: String) {
        let title = "Error"
        AlertController.presentAlertWith(title, andMessage: errorMsg)
    }
}


// MARK: Present Action Sheet
extension AlertController {
    class func presentMenuActionSheetAlertFrom(controller: UIViewController) {
        let presentView = controller as! DVBChartController
        
        
        let actionSheet = ActionController()
        let serviceAction = Action("Service Information", style: .Default) { action in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let segueId = DVBSegue.serviceInformation.rawValue
                if presentView.shouldPerformSegueWithIdentifier(segueId, sender: nil) {
                    presentView.performSegueWithIdentifier(segueId, sender: presentView)
                }
                
            }
            
        }

        let satelliteParametersAction = Action("Satellite Parameters", style: .Default) { action in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let segueId = DVBSegue.satelliteParameter.rawValue
                if presentView.shouldPerformSegueWithIdentifier(segueId, sender: nil) {
                    presentView.performSegueWithIdentifier(segueId, sender: presentView)
                }
            }
        }

        let statmuxLoadingAction = Action("Statmux Loading", style: .Default) { action in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let segueId = DVBSegue.statmuxLoading.rawValue
                if presentView.shouldPerformSegueWithIdentifier(segueId, sender: nil) {
                    presentView.performSegueWithIdentifier(segueId, sender: presentView)
                }
            }
        }
        
        let cancelAction = Action("Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(serviceAction)
        actionSheet.addAction(satelliteParametersAction)
        actionSheet.addAction(statmuxLoadingAction)
        actionSheet.addSection(Section())
        actionSheet.addAction(cancelAction)
        
        presentView.presentViewController(actionSheet, animated: true, completion: nil)
    }
}


// MARK: Present Alert with title and message
extension AlertController {
    
    class func presentAlertWith(title: String, andMessage msg: String) {
        let alert = AlertController(title: title, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(okAction)
        
        alert.show()
    }
}


// MAKR: Show animated
private extension AlertController {
    func show(animated: Bool) {
        let blankVC = UIViewController()
        blankVC.view.backgroundColor = UIColor.clearColor()
        
        let screenBounds = UIScreen.mainScreen().bounds
        let window = UIWindow(frame: screenBounds)
        window.rootViewController = blankVC
        window.backgroundColor = UIColor.clearColor()
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        self.alertWindow = window
        
        
        blankVC.presentViewController(self, animated: true, completion: nil)
    }
}
