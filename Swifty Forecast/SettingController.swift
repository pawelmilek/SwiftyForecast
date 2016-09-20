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

class SettingController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    private let dataSource = [
                                [UnitType.Imperial.description, UnitType.Metric.description],
                                ["5 days", "16 days"]
                             ]
    private let UnitDimension = 0
    private let ForecastDimension = 1
    private var settingsWereChanged: Bool = false
    var delegate: SwiftyForecastControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            if self.settingsWereChanged == true {
                self.delegate?.didRequestWeatherForecast()    
            }
            
        }
    }
}


// MARK: Setup
private extension SettingController {
    func setup() -> () {
        self.view.backgroundColor = UIColor.spray()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.loadSettingsIntoPickerView()
        
    }
    
    func loadSettingsIntoPickerView() {
        let currentUnitType = Setting.unitType.rawValue
        let currentForecast = "\(Setting.forecastForDays) days"
        /*
        if let indexOfUnit = self.dataSource[UnitDimension].indexOf(currentUnitType),
            indexOfForecast = self.dataSource[ForecastDimension].indexOf(currentForecast) {
                
            self.pickerView.selectRow(indexOfUnit, inComponent: UnitDimension, animated: false)
            self.pickerView.selectRow(indexOfForecast, inComponent: ForecastDimension, animated: false)
        }
        */
    }
}


// MARK: UIPickerViewDataSource
extension SettingController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[component][row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.settingsWereChanged = true
        
        switch component {
        //case UnitDimension:             // UnitType
            //guard let unitType = UnitType(rawValue: self.dataSource[component][row]) else { fatalError("Couldn't get unit dimension.") }
            //Setting.unitType = unitType
            
        case ForecastDimension:           // Forecast
            let substrings = self.dataSource[component][row].componentsSeparatedByString(" ")
            guard let forecast = Int(substrings[0]) else { fatalError("Couldn't get forecast dimension.") }
            Setting.forecastForDays = forecast
        
        default:
            break
        }
    }
    
    // MARK: Change UIPickerView font size
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        
        if( view == nil) {
            pickerLabel = UILabel()
        }
        
        if (component == UnitDimension) {
            pickerLabel.textAlignment = .Center
        
            let rowText = self.dataSource[UnitDimension][row]
            let attributedRowText = NSMutableAttributedString(string: rowText)
            let attributedRowTextLength = attributedRowText.length

            attributedRowText.addAttribute(NSForegroundColorAttributeName, value: UIColor.ecstasy(),
                range: NSRange(location: 0, length: attributedRowTextLength))

            attributedRowText.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica", size: 40.0)!,
                range: NSRange(location: 0 ,length:attributedRowTextLength))

            pickerLabel!.attributedText = attributedRowText
            return pickerLabel as UIView
        
        } else if component == ForecastDimension {
            pickerLabel.textAlignment = .Center

            let rowText = self.dataSource[ForecastDimension][row]
            let attributedRowText = NSMutableAttributedString(string: rowText)
            let attributedRowTextLength = attributedRowText.length

            attributedRowText.addAttribute(NSForegroundColorAttributeName, value: UIColor.ecstasy(),
                range: NSRange(location: 0, length: attributedRowTextLength))

            attributedRowText.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica", size: 40.0)!,
                range: NSRange(location: 0 ,length:attributedRowTextLength))

            pickerLabel!.attributedText = attributedRowText
            return pickerLabel as UIView
        }
        
        return pickerLabel as UIView
    }
}

// MARK: UIPickerViewDelegate
extension SettingController: UIPickerViewDelegate {
    
}
