//
//  SwiftyForecastController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import CoreLocation



class SwiftyForecastController: UIViewController, CityListSelectDelegate, CustomViewLayoutSetupable, CustomViewSetupable {
    fileprivate var measuringSystemSwitch: UISegmentedControl! = nil
    fileprivate var backgroundImageView: UIImageView! = nil
    fileprivate var scrollView: UIScrollView! = nil
    fileprivate var currentWeatherView: CurrentWeatherView! = nil
    fileprivate var hourlyForecastView: HourlyForecastView! = nil
    fileprivate var dailyForecastView: DailyForecastView! = nil
    fileprivate var locationDatastore: LocationDatastore?
    fileprivate var city: City?
    var isConstraints = true
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addObserver()
    }
    
    deinit {
        self.removeObserver()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupLayout()
        self.setupStyle()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.retrieveWeatherData()
    }
}


// MARK: Preper For Seuge
extension SwiftyForecastController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == SegueIdentifier.showCityListSegue {
            guard let cityListVC = segue.destination as? CityListTableController else { return }
            cityListVC.delegate = self
        }
    }
}


// MARK: CityListSelectDelegate
extension SwiftyForecastController {
    
    func cityListDidSelect(city: City) {
        self.city = city
    }
}


// MARK: CustomViewSetupable
extension SwiftyForecastController {
    func setup() {
        func setupBackgroundImageView() {
            self.backgroundImageView = UIImageView(frame: self.view.bounds)
            self.backgroundImageView.contentMode = .scaleAspectFill
            self.backgroundImageView.clipsToBounds = true
            self.backgroundImageView.image = UIImage(named: "background-default.png")
            self.view.addSubview(self.backgroundImageView)
        }
        
        func setupScrollViewSubViews() {
            self.currentWeatherView = CurrentWeatherView(frame: CGRect.zero)
            self.hourlyForecastView = HourlyForecastView(frame: CGRect.zero)
            self.dailyForecastView = DailyForecastView(frame: CGRect.zero)
        }
        
        
        func setupScrollView() {
            self.scrollView = UIScrollView(frame: self.view.bounds)
            self.scrollView.showsVerticalScrollIndicator = false
            
            self.scrollView.addSubview(self.currentWeatherView)
            self.scrollView.addSubview(self.hourlyForecastView)
            self.scrollView.addSubview(self.dailyForecastView)
            self.view.addSubview(self.scrollView)
        }
        
        func setScrollViewBorder() {
            self.scrollView.layer.borderWidth = 1
            self.scrollView.layer.borderColor = UIColor.yellow.cgColor
        }
        
        func setMetricSystemSwitch() {
            self.measuringSystemSwitch = UISegmentedControl(items: ["℉", "℃"])
            self.measuringSystemSwitch.frame = CGRect(x: 0, y: 0, width: 130, height: 25)
            self.measuringSystemSwitch.selectedSegmentIndex = 0
            self.measuringSystemSwitch.addTarget(self, action: #selector(SwiftyForecastController.segmentedControllerTapped(_:)), for: .valueChanged)
            self.navigationItem.titleView = self.measuringSystemSwitch
        }
        
        
        setupBackgroundImageView()
        setupScrollViewSubViews()
        setupScrollView()
        setMetricSystemSwitch()
        // MARK: TEST to keep track on the view size and position
        //setScrollViewBorder()
        
        
        
    }
    
    
    func setupLayout() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        
        func setBackgroundConstrains() {
            constrain(self.backgroundImageView) { view in
                view.top == view.superview!.top
                view.bottom == view.superview!.bottom
                view.left == view.superview!.left
                view.right == view.superview!.right
            }
        }
        
        func setScrollViewConstrains() {
            /*
             * StatusBar is usually 20pt height, but it can change in situations:
             * - when in the middle of call
             * - when any app is using the microphone
             * - when Hotspot is activated
             */
            constrain(self.scrollView) { view in
                view.top == view.superview!.top + (statusBarHeight + navigationBarHeight)
                view.bottom == view.superview!.bottom
                view.left == view.superview!.left
                view.right == view.superview!.right
            }
        }
        
        func setCurrentWeatherViewConstrains() {
            constrain(self.currentWeatherView) { view in
                view.width == view.superview!.width
                view.centerX == view.superview!.centerX
                
                // set view at the bottom of the scrollView to enable scrolling
                view.top == view.superview!.top + (statusBarHeight + navigationBarHeight)
            }
        }
        
        func setHourlyForecastViewConstrains() {
            
        }
        
        func setDailyForecastViewConstrains() {
            let bottomMargin: CGFloat = 8
            
            constrain(self.dailyForecastView, self.currentWeatherView) { view, view2 in
                view.top == view2.bottom + bottomMargin
                view.width == view.superview!.width
                view.bottom == view.superview!.bottom - bottomMargin
                view.centerX == view.superview!.centerX
            }
        }
        
        setBackgroundConstrains()
        setScrollViewConstrains()
        setCurrentWeatherViewConstrains()
        setHourlyForecastViewConstrains()
        setDailyForecastViewConstrains()
    }
    
    
    func setupStyle() {
        self.measuringSystemSwitch.tintColor = .white
    }
}


// MARK: Actions
extension SwiftyForecastController {
    
    @objc func segmentedControllerTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            MeasuringSystem.isMetric = false    // default, need to store user choose in local dba, UserDefaults.standard
        } else {
            MeasuringSystem.isMetric = true
        }
        
        self.notifyObserver()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        self.retrieveWeatherData()
        //print("refreshButtonTapped")
    }
    
}



// MARK: NotificationCenter
extension SwiftyForecastController {
    
    func addObserver() {
        let defaultCenter = NotificationCenter.default
        let name = NotificationCenterKey.measuringSystemDidSwitcheNotification
        
        defaultCenter.addObserver(self, selector: #selector(SwiftyForecastController.measuringSystemSwitched(_:)), name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func notifyObserver() {
        let notificationCenterKey = NotificationCenterKey.measuringSystemDidSwitcheNotification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationCenterKey), object: nil)
    }
    
    @objc func measuringSystemSwitched(_ notification: NSNotification) {
        print(NotificationCenterKey.measuringSystemDidSwitcheNotification)
        self.retrieveWeatherData()
    }
    
}



// MAKR: Retrieve Weather Data from JSON
fileprivate extension SwiftyForecastController {
    
    func retrieveWeatherData() {
        // Prevent Reference Cycles with Closure [weak weakSelf = self]
        self.locationDatastore = LocationDatastore() { [weak weakSelf = self] cityLocation in
            let weatherDatastore = WeatherDatastore()
            var mutableLocation = cityLocation
            
            if let selectedCity = self.city {
                mutableLocation = Coordinate(latitude: selectedCity.latitude, longitude: selectedCity.longitude)
                //print("selectedCity \(selectedCity.fullName): latitude \(mutableLocation.latitude), longitude \(mutableLocation.longitude)")
            }
            
            
            weatherDatastore.retrieveCurrentWeather(at: mutableLocation) { currentConditions in
                weakSelf?.currentWeatherView.renderView(weather: currentConditions)
                return
            }
            
            weatherDatastore.retrieveHourlyWeather(at: mutableLocation, forecast: ConstantValue.numberOfHours) { hourlyConditions in
                weakSelf?.hourlyForecastView.renderView(weathers: hourlyConditions)
                return
            }
            
            weatherDatastore.retrieveDailyForecast(at: mutableLocation, forecast: ConstantValue.numberOfDays) { dailyConditions in
                weakSelf?.dailyForecastView.renderView(weathers: dailyConditions)
                return
            }
        }
    }
}

