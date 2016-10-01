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
    fileprivate var dailyForecastView: DailyForecastView! = nil
    fileprivate var locationDatastore: LocationDatastore?
    fileprivate var city: City?
    var isConstraints = true
    
    
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
            self.dailyForecastView = DailyForecastView(frame: CGRect.zero)
        }
        
        
        func setupScrollView() {
            self.scrollView = UIScrollView(frame: self.view.bounds)
            self.scrollView.showsVerticalScrollIndicator = false
            
            self.scrollView.addSubview(self.currentWeatherView)
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
                let statusBarHeight = UIApplication.shared.statusBarFrame.height
                let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
                
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
                view.top == view.superview!.top + CGFloat(64) //centerY
            }
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
        setDailyForecastViewConstrains()
    }
    
    
    func setupStyle() {
        self.measuringSystemSwitch.tintColor = .white
    }
}


// MARK: Actions
extension SwiftyForecastController {
    
    func segmentedControllerTapped(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment {
        case 0:
            print("Fahrenheit")
            
        case 1:
            print("Celsius")
            
        default:
            break
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        self.retrieveWeatherData()
        //print("refreshButtonTapped")
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
                mutableLocation.latitude = selectedCity.latitude
                mutableLocation.longitude = selectedCity.longitude
                //print("selectedCity \(selectedCity.fullName): latitude \(mutableLocation.latitude), longitude \(mutableLocation.longitude)")
            }
            
            
            weatherDatastore.retrieveCurrentWeatherAt(latitude: mutableLocation.latitude, longitude: mutableLocation.longitude) { currentConditions in
                weakSelf?.currentWeatherView.renderView(weather: currentConditions)
                return
            }
            
            weatherDatastore.retrieveDailyForecastAt(latitude: mutableLocation.latitude, longitude: mutableLocation.longitude, forecast: ConstantValue.numberOfDays) { dailyConditions in
                weakSelf?.dailyForecastView.renderView(weathers: dailyConditions)
                return
            }
        }
    }
}


