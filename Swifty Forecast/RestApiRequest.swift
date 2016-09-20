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
import SwiftyJSON


final class RestApiRequest {
    private var queue: NSOperationQueue = NSOperationQueue.mainQueue()
    private(set) var completionData: NSData?
    private var error: NSError?
    var delegate: RestApiRequestDelegate?
    
    
    func fetchDataFrom(url url: String, completion: () -> ()) {
        if let dataUrl = NSURL(string: url) {
            let request = NSURLRequest(URL: dataUrl, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
            let session = NSURLSession.sharedSession()
            
            session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                self.error = error
                self.completionData = data
                
                if let _ = self.completionData where self.error == nil {
                    self.delegate?.didFetchDataFrom(self)
                    completion()
                    
                } else {
                    self.fetchedInvalidData()
                }
                
            }).resume()
        
        } else {
            print("Error - not a valid URL")
        }
    }
    
    
    private func fetchedInvalidData() {
        if self.completionData == nil && self.error == nil {
            print("No data was downloaded")
            
        } else if self.error != nil {
            print("Unknown fatal error. OpenWeatherMap returned invalid JSON object.")
        }
    }
}

// MARK: Shared Instance
extension RestApiRequest {
    static var sharedInstance: RestApiRequest {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: RestApiRequest? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = RestApiRequest()
        }
        
        return Static.instance!
    }
}
