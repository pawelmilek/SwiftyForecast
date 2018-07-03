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

class SwiftyForecastController: UIViewController, CityListSelectDelegate, ViewSetupable {
  private var measuringSystemSwitch: UISegmentedControl! = nil
  private var backgroundImageView: UIImageView! = nil
  private var scrollView: UIScrollView! = nil
  private var currentWeatherView: CurrentWeatherView! = nil
  private var hourlyForecastView: HourlyForecastView! = nil
  private var dailyForecastView: DailyForecastView! = nil
  
  private var city: City?
  
  var weatherForecast: WeatherForecast? {
    didSet {
      guard let weatherForecast = weatherForecast else { return }
      currentWeatherView.renderView(for: weatherForecast.currently, and: weatherForecast.city)
      dailyForecastView.renderView(for: weatherForecast.daily)
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    retrieveWeatherData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupLayout()
    setupStyle()
  }
}


// MARK: - Preper For Seuge
extension SwiftyForecastController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    if identifier == SegueIdentifierType.showCityListSegue.rawValue {
      guard let cityListVC = segue.destination as? CityListTableController else { return }
      cityListVC.delegate = self
    }
  }
}


// MARK: - CityListSelectDelegate protocol
extension SwiftyForecastController {
  
  func cityListDidSelect(city: City) {
    self.city = city
  }
}



// MARK: - CustomViewSetupable
extension SwiftyForecastController {
  func setup() {
    func setupBackgroundImageView() {
      backgroundImageView = UIImageView(frame: view.bounds)
      backgroundImageView.contentMode = .scaleAspectFill
      backgroundImageView.clipsToBounds = true
      backgroundImageView.image = UIImage(named: "background-default.png")
      view.addSubview(backgroundImageView)
    }
    
    func setupScrollViewSubViews() {
      currentWeatherView = CurrentWeatherView(frame: CGRect.zero)
      hourlyForecastView = HourlyForecastView(frame: CGRect.zero)
      dailyForecastView = DailyForecastView(frame: CGRect.zero)
    }
    
    
    func setupScrollView() {
      scrollView = UIScrollView(frame: view.bounds)
      scrollView.showsVerticalScrollIndicator = false
      
      scrollView.addSubview(currentWeatherView)
      scrollView.addSubview(hourlyForecastView)
      scrollView.addSubview(dailyForecastView)
      view.addSubview(scrollView)
    }
    
    func setScrollViewBorder() {
      scrollView.layer.borderWidth = 1
      scrollView.layer.borderColor = UIColor.yellow.cgColor
    }
    
    func setMetricSystemSwitch() {
      measuringSystemSwitch = UISegmentedControl(items: ["℉", "℃"])
      measuringSystemSwitch.frame = CGRect(x: 0, y: 0, width: 130, height: 25)
      measuringSystemSwitch.selectedSegmentIndex = 0
      measuringSystemSwitch.addTarget(self, action: #selector(SwiftyForecastController.segmentedControllerTapped(_:)), for: .valueChanged)
      navigationItem.titleView = measuringSystemSwitch
    }
    
    
    setupBackgroundImageView()
    setupScrollViewSubViews()
    setupScrollView()
    setMetricSystemSwitch()
  }
  
  
  func setupLayout() {
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
    
    
    func setBackgroundConstrains() {
      constrain(backgroundImageView) { view in
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
      constrain(scrollView) { view in
        view.top == view.superview!.top + (statusBarHeight + navigationBarHeight)
        view.bottom == view.superview!.bottom
        view.left == view.superview!.left
        view.right == view.superview!.right
      }
    }
    
    func setCurrentWeatherViewConstrains() {
      constrain(currentWeatherView) { view in
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
      
      constrain(dailyForecastView, currentWeatherView) { view, view2 in
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
    measuringSystemSwitch.tintColor = .white
  }
}


// MARK: - Actions
extension SwiftyForecastController {
  
  @objc func segmentedControllerTapped(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      MeasuringSystem.isMetric = false // default, need to store user choose in local dba, UserDefaults.standard
    } else {
      MeasuringSystem.isMetric = true
    }
    
    measuringSystemSwitched()
  }
  
  @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
    retrieveWeatherData()
  }
  
}



// MARK: - Measuring System switched
extension SwiftyForecastController {
  
  func measuringSystemSwitched() {
    retrieveWeatherData()
  }
  
}



// MAKR: Retrieve Weather Data from JSON
private extension SwiftyForecastController {
  
  func retrieveWeatherData() {
    LocationProvider.shared.getCurrentLocation() { [weak self] cityLocation in
      let request = ForecastRequest.make(by: cityLocation)
      WebService.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
        switch response {
        case .success(let forecast):
          print(forecast)
          let currentCityCoord = Coordinate(latitude: forecast.latitude, longitude: forecast.longitude)
          Geocoder.findCity(at: currentCityCoord) { [weak self] city in
            self?.weatherForecast = WeatherForecast(city: city, currently: forecast.currently, hourly: forecast.hourly, daily: forecast.daily)
          }
          
        case .failure(let error):
          error.handle()
        }
      })
    }
  }
  
}

