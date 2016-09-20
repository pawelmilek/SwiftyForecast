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



class TwelveHoursCollectionController: UICollectionViewController {
    private let reuseIdentifier = "twelveHoursCell"
    var hourlyConditions: [HourlyCondition] = [HourlyCondition]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.backgroundColor = .clearColor()
        self.collectionView?.opaque = false
        self.collectionView?.backgroundView = nil
    }
}


// MARK: UICollectionViewDataSource
extension TwelveHoursCollectionController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourlyConditions.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: HourlyForecastCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HourlyForecastCollectionCell
        
        guard self.hourlyConditions.count > 0 else {
            print("No data in hourlyCondition property")
            return cell
        }
        
        let row = indexPath.row
        let nextHourCondition: HourlyCondition = self.hourlyConditions[row]
        
        cell.timeLabel.text = nextHourCondition.date.time
        cell.conditionImage.image = nextHourCondition.image
        if let currentTemp = nextHourCondition.temperature.currentlyTemperature() {
            cell.hourlyTemperatureLabel.text = "\(currentTemp) \(nextHourCondition.temperature.symbol())"
        }
        
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension TwelveHoursCollectionController {
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    
        cell.backgroundColor = .clearColor()
    }
}
