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
import CoreLocation


class SwiftyForecastController: UIViewController {
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var sunriseImage: UIImageView!
    @IBOutlet weak var sunsetImage: UIImageView!
    @IBOutlet weak var windCompass: UIImageView!
    @IBOutlet weak var moonPhaseImage: UIImageView!
    @IBOutlet weak var currentTemperatureImage: UIImageView!
    
    @IBOutlet weak var longDescLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windSpeedAndDirectionLabel: UILabel!
    @IBOutlet weak var moonPhaseLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    private let forecastCell = "ForecastCell"
    private var locationManager: CLLocationManager!
    private var forecastParser: ForecastParser = ForecastParser()
    private var weather: SwiftyWeather = SwiftyWeather()
    private var sixDaysContainer: SixDaysCollectionController?
    private var twelveHoursContainer: TwelveHoursCollectionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupLayout()
        self.initLocationManager()
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /* ************************************************************************************************ *
         * To send information back from the destination view controller to the source view controller.
         * A common way to handle that situation is to add a delegate property to the destination,
         * and then in the source view controller's prepareForSegue(...),
         * set the destination view controller's delegate property to self.
         * (and define a protocol that defines the messages the destination ViewController uses
         * to send messages to the source ViewController).
         * ************************************************************************************************ */
        if segue.identifier == "settings" {
            let destination = segue.destinationViewController as! SettingController
            destination.delegate = self
            print("SettingController")
        }
    }
    */
}

// MARK: Setup
private extension SwiftyForecastController {
    
    func setup() {
        func assignDataSourceForForecastCollectionView() {
            //self.forecastCollectionView.dataSource = self
        }
        
        func assignDelegateForRestApiRequestAndForecastParser() {
            RestApiRequest.sharedInstance.delegate = self.forecastParser
            self.forecastParser.delegate = self.weather
        }
        
//        func connectToDatabase() {
//            DBManager.sharedInstance.connect()
//        }
        
        
        assignDataSourceForForecastCollectionView()
        assignDelegateForRestApiRequestAndForecastParser()
//        connectToDatabase()
    }
}


// MARK: Setup Layout
private extension SwiftyForecastController {
    
    func setupLayout() {
        
        func navigationBarBottomHairline(hide hide: Bool) {
            if let navigationCtrl = self.navigationController {
                navigationCtrl.navigationBar.clipsToBounds = hide
            }
        }
        
        func clearCurrentDayLabels() {
            self.weekdayLabel.text = ""
            self.timeLabel.text = ""
            self.dateLabel.text = ""
            self.longDescLabel.text = ""
            self.sunriseLabel.text = ""
            self.sunsetLabel.text = ""
            self.currentTemperatureLabel.text = ""
            self.windSpeedAndDirectionLabel.text = ""
            self.moonPhaseLabel.text = ""
        }
        
        clearCurrentDayLabels()
        self.currentLocationLabel.text = "Current Location"
        //navigationBarBottomHairline(hide: true)
    }
}


// MARK: Location Manager
extension SwiftyForecastController: CLLocationManagerDelegate {
    
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 200
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            self.weather.location = Location(city: "na", country: "na", coordinate: Coordinate(latitude: latitude, longitude: longitude))
            self.fetchingForecastData()
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
    // Verify Authorization status
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var locationStatus = "Not Started"
        var allowAccessToLocation = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location."
            
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location."
            
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined."
            
        default:
            locationStatus = "Allowed to location Access."
            allowAccessToLocation = true
        }
        
        if (allowAccessToLocation == true) {
            self.locationManager.startUpdatingLocation()
            print("Location Allowed")
            
        } else {
            print("Denied access: \(locationStatus)")
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationManager?.stopUpdatingLocation()
        print("Location Manager didFailWithError: \(error.description)")
    }
}


// MARK: Fetching Weather Forecast
private extension SwiftyForecastController {
    
    func fetchingForecastData() {
        let completeURL = self.weather.forecastURL

        RestApiRequest.sharedInstance.fetchDataFrom(url: completeURL, completion: {
            //self.sixDaysContainer?.dailyConditions = self.weather.dailyConditions
            //self.twelveHoursContainer?.hourlyConditions = self.weather.hourlyConditions
            
            self.renderAndReloadLayoutViewContent()
        })
    }
}


// MARK: Render and Reload View Layout
private extension SwiftyForecastController {
    
    func renderAndReloadLayoutViewContent() {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            //self.setNavigationItemTitleAttributes()
            self.renderViewLayoutForCurrentDay()
            self.reloadForecastCollectionViewData()
        })
    }
}


// MARK: Set Navigation Item Title Attributes
private extension SwiftyForecastController {
    
    func setNavigationItemTitleAttributes() {
        func setTitleColorAndFont() {
            self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
            self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 37.0)!]
        }
        
        func setTitle() {
            self.navigationItem.title = "Current Location"
        }
        
        
        setTitleColorAndFont()
        setTitle()
    }
}


// MARK: Render Current Day
private extension SwiftyForecastController {
    
    func renderViewLayoutForCurrentDay() {
        self.renderMoonPhase()
        self.renderSunState()
        self.renderDateLabels()
        self.renderDescriptionLabel()
        self.renderWindLabels()
        self.renderConditionImage()
        self.renderTemperatureLabels()
    }
    
    
    func renderMoonPhase() {
        if let currently = self.weather.currentCondition {
            self.moonPhaseImage.image = currently.sunAndMoonState.moonPhase.image
            self.moonPhaseLabel.text = currently.sunAndMoonState.moonPhase.description
        }
    }
    
    func renderSunState() {
        if let sun = self.weather.currentCondition?.sunAndMoonState.sunState {
            self.sunriseLabel.text = sun.sunriseTime
            self.sunsetLabel.text = sun.sunsetTime
            
            if let sunriseIcon = Icon(rawValue: "sunrise"), sunsetIcon = Icon(rawValue: "sunset") {
                self.sunriseImage.image = sunriseIcon.image
                self.sunsetImage.image = sunsetIcon.image
            }
        }
    }
    
    func renderDateLabels() {
        if let dateTime = self.weather.currentCondition?.date {
            self.weekdayLabel.text = dateTime.weekday
            self.timeLabel.text = dateTime.time
            self.dateLabel.text = dateTime.dayAndMonth
        }
    }
    
    func renderDescriptionLabel() {
        if let condition = self.weather.currentCondition {
            self.longDescLabel.text = condition.summaryDescription
        }
    }
    
    
    func renderWindLabels() {
        if let wind = self.weather.currentCondition?.wind {
            self.windCompass.image = wind.compassIcon
            self.windSpeedAndDirectionLabel.text = "\(wind.speedValue())" + wind.speedSymbol() + " " + wind.direction
        }
    }
    
    
    func renderConditionImage() {
        if let condition = self.weather.currentCondition {
            self.weatherConditionImage.image = condition.image
        }
    }
    
    func renderTemperatureLabels() {
        if let currently = self.weather.currentCondition, currentlyTemp = currently.temperatureCurrently() {
            self.currentTemperatureLabel.text = "\(currentlyTemp) \(currently.temperature.symbol())"
            self.currentTemperatureImage.image = currently.temperature.icon
        }
    }
}


// MARK: Reload CollectionView Data
private extension SwiftyForecastController {
    
    func reloadForecastCollectionViewData() {
        self.sixDaysContainer?.dailyConditions = self.weather.dailyConditions
        self.twelveHoursContainer?.hourlyConditions = self.weather.hourlyConditions
        
        self.sixDaysContainer?.collectionView?.reloadData()
        self.twelveHoursContainer?.collectionView?.reloadData()
    }
}


// MARK: Actions
private extension SwiftyForecastController {
    
    @IBAction func onSegmentedControlSwitchUnit(sender: UISegmentedControl) {
        guard let selectedMeasuringSystem = MeasuringSystem(rawValue: sender.selectedSegmentIndex) else { return }
        
        Setting.measuringSystem = selectedMeasuringSystem
        self.weather.changeConditionsMeasuringSystem()
        
        self.renderTemperatureLabels()
        self.renderWindLabels()
        self.reloadForecastCollectionViewData()
    }
}



// MARK: Alert Controller
private extension SwiftyForecastController {
    
    func showAlertWithTitleAndMessage(title title: String, message: String) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.createAndPresentAlert(title: title, message: message)
        })
    }
    
    func createAndPresentAlert(title title: String, message msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: { action in
            switch action.style {
            case .Default:
                print("Default")
                
            case .Cancel:
                print("Cancel")
                
            case .Destructive:
                print("Destructive")
            }
        })
        
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

// MARK: Prepare For Segue
extension SwiftyForecastController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sixDaysForecast" {
            let childSixDaysViewController = segue.destinationViewController as! SixDaysCollectionController
            self.sixDaysContainer = childSixDaysViewController
            
        } else if segue.identifier == "twelveHoursForecast" {
            let childTwelveHoursViewController = segue.destinationViewController as! TwelveHoursCollectionController
            self.twelveHoursContainer = childTwelveHoursViewController
        }
    }
}
