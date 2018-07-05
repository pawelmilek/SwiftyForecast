//
//  SwiftyForecastViewController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class SwiftyForecastViewController: UIViewController, CityListSelectDelegate, ViewSetupable {
  @IBOutlet weak var currentForecastView: CurrentForecastView!
  
  private lazy var measuringSystemSegmentedControl: SegmentedControl = {
    let segmentedControl = SegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    segmentedControl.items = ["℉", "℃"]
    segmentedControl.font = UIFont(name: "AvenirNext-Bold", size: 14)
    segmentedControl.selectedLabelColor = .orange
    segmentedControl.unselectedLabelColor = .white
    segmentedControl.backgroundColor = .clear
    segmentedControl.borderColor = .white
    segmentedControl.thumbColor = .white
    segmentedControl.selectedIndex = 0
    segmentedControl.addTarget(self, action: #selector(SwiftyForecastViewController.measuringSystemSwitched(_:)), for: .valueChanged)
    return segmentedControl
  }()
  
  
  private var backgroundImageView: UIImageView! = nil
  private var scrollView: UIScrollView! = nil
  private var currentWeatherView: CurrentWeatherView! = nil
  private var dailyForecastView: DailyForecastView! = nil
  
  private var city: City?
  
  var weatherForecast: WeatherForecast? {
    didSet {
      guard let weatherForecast = weatherForecast else { return }
      currentWeatherView.renderView(for: weatherForecast.currently, and: weatherForecast.city)
      dailyForecastView.renderView(for: weatherForecast.daily)
      
      currentForecastView.currentForecast = weatherForecast.currently
      currentForecastView.hourlyForecast = weatherForecast.hourly
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    fetchWeatherForecast()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupLayout()
    
    view.bringSubview(toFront: currentForecastView)
  }
}


// MARK: - Preper For Seuge
extension SwiftyForecastViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier, identifier == SegueIdentifierType.showCityListSegue.rawValue else { return }
    guard let cityListVC = segue.destination as? CityListTableViewController else { return }
    
    cityListVC.delegate = self
  }
}


// MARK: - CityListSelectDelegate protocol
extension SwiftyForecastViewController {
  
  func cityListDidSelect(city: City) {
    self.city = city
  }
}



// MARK: - CustomViewSetupable
extension SwiftyForecastViewController {
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
      dailyForecastView = DailyForecastView(frame: CGRect.zero)
    }
    
    
    func setupScrollView() {
      scrollView = UIScrollView(frame: view.bounds)
      scrollView.showsVerticalScrollIndicator = false
      
      scrollView.addSubview(currentWeatherView)
      scrollView.addSubview(dailyForecastView)
      view.addSubview(scrollView)
    }
    
    
    func setMetricSystemSwitch() {
      navigationItem.titleView = measuringSystemSegmentedControl
    }
    
    
    setupBackgroundImageView()
    setupScrollViewSubViews()
    setupScrollView()
    setMetricSystemSwitch()
    
    
    currentForecastView.delegate = self
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
    setDailyForecastViewConstrains()
  }
}


// MAKR: Fetch weather forecast
private extension SwiftyForecastViewController {
  
  func fetchWeatherForecast() {
    LocationProvider.shared.getCurrentLocation() { [weak self] cityLocation in
      let request = ForecastRequest.make(by: cityLocation)
      WebService.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
        switch response {
        case .success(let forecast):
          let currentCityCoord = Coordinate(latitude: forecast.latitude, longitude: forecast.longitude)
          
          Geocoder.findCity(at: currentCityCoord) { [weak self] city in
            DispatchQueue.main.async {
              self?.weatherForecast = WeatherForecast(city: city, currently: forecast.currently, hourly: forecast.hourly, daily: forecast.daily)
            }
          }
          
        case .failure(let error):
          error.handle()
        }
      })
    }
  }
  
}


// MARK: - topDistance
extension SwiftyForecastViewController: CurrentForecastViewDelegate {
  
  var topDistance: CGFloat {
    get {
      guard self.navigationController != nil else {
        return 0
      }
      let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
      let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
      return barHeight + statusBarHeight
      
    }
  }
  
  
  func currentForecastDidExpand() {
    print("currentForecastDidExpand")
    
    self.currentForecastView.moreDetailsViewConstraint.constant = 0
    UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
      let height = self.view.frame.size.height - (2 * self.topDistance)
      self.currentForecastView.frame.size.height = height
      
    }, completion: { completed in
      if completed {
        self.currentForecastView.moreDetailsViewConstraint.constant = 128
        self.view.layoutIfNeeded()
      }
    })
  }
  
  func currentForecastDidCollapse() {
    print("currentForecastDidCollapse")
    
    self.currentForecastView.moreDetailsViewConstraint.constant = 128
    UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
      self.currentForecastView.frame.size.height = 305
      
    }, completion: { completed in
      if completed {
        self.currentForecastView.moreDetailsViewConstraint.constant = 0
        self.view.layoutIfNeeded()
      }
    })
  }
  
}


// MARK: - Actions
extension SwiftyForecastViewController {
  
  @objc func measuringSystemSwitched(_ sender: SegmentedControl) {
    MeasuringSystem.isMetric = (sender.selectedIndex == 0 ? false : true)
    fetchWeatherForecast()
  }
  
  @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
    fetchWeatherForecast()
  }
  
}
