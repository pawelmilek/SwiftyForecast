//
//  ForecastContentViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ForecastContentViewController: UIViewController {
  @IBOutlet private weak var currentForecastView: CurrentForecastView!
  @IBOutlet private weak var dailyForecastTableView: UITableView!
  
  private let sharedMOC = CoreDataStackHelper.shared
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToMoreDetailsBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint?
  
  var currentCityForecast: City?
  var weatherForecast: WeatherForecast? {
    didSet {
      guard let weatherForecast = weatherForecast else { return }
      currentForecastView.configure(current: weatherForecast.currently, at: weatherForecast.city)
      currentForecastView.configure(hourly: weatherForecast.hourly)
      dailyForecastTableView.reloadData()
    }
  }
  
  var pageIndex: Int = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchWeatherForecast()
  }
  
  deinit {
    removeNotificationCenterObservers()
  }
}


// MARK: - ViewSetupable protocol
extension ForecastContentViewController: ViewSetupable {
  
  func setup() {
    setCurrentForecastViewDelegate()
    setSupportingCurrentForecastViewConstraints()
    setDailyForecastTableView()
    addNotificationCenterObservers()
    
  }
  
}


// MARK: - Private - Set currentForecastView delegate
private extension ForecastContentViewController {
  
  func setCurrentForecastViewDelegate() {
    currentForecastView.delegate = self
  }
  
}


// MARK: - Private - Set currentForecastView constraints
private extension ForecastContentViewController {
  
  func setSupportingCurrentForecastViewConstraints() {
    currentForecastViewMoreDetailsViewBottomConstraint = currentForecastView.moreDetailsViewBottomConstraint
    currentForecastViewStackViewBottomToMoreDetailsBottomConstraint = currentForecastView.stackViewBottomToMoreDetailsTopConstraint
    currentForecastViewStackViewBottomToSafeAreaBottomConstraint = currentForecastView.stackViewBottomToSafeAreaBottomConstraint
    dailyForecastTableViewBottomConstraint = currentForecastView.bottomAnchor.constraint(equalTo: self.dailyForecastTableView.bottomAnchor, constant: 0)
  }
}


// MARK: - Private - Set daily Forecast TableView
private extension ForecastContentViewController {
  
  func setDailyForecastTableView() {
    dailyForecastTableView.register(cellClass: DailyForecastTableViewCell.self)
    dailyForecastTableView.dataSource = self
    dailyForecastTableView.delegate = self
    dailyForecastTableView.showsVerticalScrollIndicator = false
    dailyForecastTableView.allowsSelection = false
    dailyForecastTableView.rowHeight = UITableViewAutomaticDimension
    dailyForecastTableView.estimatedRowHeight = 85
    dailyForecastTableView.backgroundColor = .white
    dailyForecastTableView.separatorStyle = .none
    dailyForecastTableView.tableFooterView = UIView()
  }
  
}


// MARK: - Private - Add notification center
private extension ForecastContentViewController {
  
  func addNotificationCenterObservers() {
    let measuringSystemSwitchName = NotificationCenterKey.measuringSystemDidSwitchNotification.name
    NotificationCenter.default.addObserver(self, selector: #selector(measuringSystemDidSwitch(_:)), name: measuringSystemSwitchName, object: nil)
    
    let refreshName = NotificationCenterKey.refreshButtonDidPressNotification.name
    NotificationCenter.default.addObserver(self, selector: #selector(refreshButtonDidTap(_:)), name: refreshName, object: nil)
  }
  
  func removeNotificationCenterObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
}


// MAKR: - Private - Fetch weather forecast
private extension ForecastContentViewController {
  
  func fetchWeatherForecast() {
    var isCurrentLocationPage: Bool {
      return pageIndex == 0
    }
    
    if isCurrentLocationPage && LocationProvider.shared.isLocationServicesEnabled { // Check current location
      fetchWeatherForecastForCurrentLocation()
      
    } else if let currentCityForecast = currentCityForecast {
      fetchWeatherForecast(for: currentCityForecast)
    }
  }
  
  
  func fetchWeatherForecastForCurrentLocation() {
    ActivityIndicatorView.shared.startAnimating(at: view)
    
    GooglePlacesHelper.getCurrentPlace() { [weak self] (place, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        ActivityIndicatorView.shared.stopAnimating()
        error == .locationDisabled ? strongSelf.presentLocationServicesSettingsPopupAlert() : error.handle()
        return
      }
      
      
      if let place = place {
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        let request = ForecastRequest.make(by: coordinate)
        
        WebService.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
          switch response {
          case .success(let forecast):
            DispatchQueue.main.async {
              let unassociatedCity = City(place: place)
              strongSelf.weatherForecast = WeatherForecast(city: unassociatedCity, forecastResponse: forecast)
              
              if City.isDuplicate(city: unassociatedCity) == false {
                let newCurrentCity = City(unassociatedObject: unassociatedCity, isCurrentLocalized: true, managedObjectContext: strongSelf.sharedMOC.mainContext)
                strongSelf.currentCityForecast = newCurrentCity
                
                do {
                  try strongSelf.sharedMOC.mainContext.save()
                } catch {
                  CoreDataError.couldNotSave.handle()
                }
              }
              
              ActivityIndicatorView.shared.stopAnimating()
            }
            
          case .failure(let error):
            DispatchQueue.main.async {
              ActivityIndicatorView.shared.stopAnimating()
              error.handle()
            }
          }
        })
        
      } else {
        ActivityIndicatorView.shared.stopAnimating()
        GooglePlacesError.placeNotFound.handle()
      }
    }
  }
  
  
  func fetchWeatherForecast(for city: City) {
    ActivityIndicatorView.shared.startAnimating(at: view)
    
    let request = ForecastRequest.make(by: city.coordinate)
    WebService.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
      switch response {
      case .success(let forecast):
        DispatchQueue.main.async {
          self.weatherForecast = WeatherForecast(city: city, forecastResponse: forecast)
          ActivityIndicatorView.shared.stopAnimating()
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          ActivityIndicatorView.shared.stopAnimating()
          error.handle()
        }
      }
    })
  }
  
}


// MARK: - Private - Show settings alert view
private extension ForecastContentViewController {
  
  func presentLocationServicesSettingsPopupAlert() {
    let cancelAction: (UIAlertAction) -> () = { _ in }
    
    let settingsAction: (UIAlertAction) -> () = { _ in
      let settingsURL = URL(string: UIApplicationOpenSettingsURLString)!
      UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    let title = NSLocalizedString("Location Services Disabled", comment: "")
    let message = NSLocalizedString("Please enable Location Based Services. We will keep your location private", comment: "")
    let actionsTitle = [NSLocalizedString("Cancel", comment: ""), NSLocalizedString("Settings", comment: "")]
    AlertViewPresenter.shared.presentPopupAlert(in: self, title: title, message: message, actionTitles: actionsTitle, actions: [cancelAction, settingsAction])
  }
  
}


// MARK: - CurrentForecastViewDelegate protocol
extension ForecastContentViewController: CurrentForecastViewDelegate {
  
  func currentForecastDidExpandAnimation() {
    animateBouncingEffect()
    
    currentForecastViewMoreDetailsViewBottomConstraint?.constant = 0
    dailyForecastTableViewBottomConstraint?.isActive = true
    currentForecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = false
    currentForecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = true
    
    UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.currentForecastView.animateLabelsScaling()
      self.view.layoutIfNeeded()
    })
  }
  
  func currentForecastDidCollapseAnimation() {
    let height = currentForecastView.frame.size.height
    
    currentForecastViewMoreDetailsViewBottomConstraint?.constant = height
    dailyForecastTableViewBottomConstraint?.isActive = false
    currentForecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = true
    currentForecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = false
    
    UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
      self.currentForecastView.animateLabelsIdentity()
      self.view.layoutIfNeeded()
    })
  }
  
}


// MARK: - Private - Animate bouncing effect
private extension ForecastContentViewController {
  
  func animateBouncingEffect() {
    currentForecastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
    UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
      self.currentForecastView.transform = .identity
    })
  }
  
}


// MARK: - UITableViewDataSource protcol
extension ForecastContentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weatherForecast?.daily.data.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dailyItems = weatherForecast?.daily.data else { return UITableViewCell() }
    
    let item = dailyItems[indexPath.row]
    let cell = tableView.dequeueCell(DailyForecastTableViewCell.self, for: indexPath)
    
    cell.configure(by: item)
    return cell
  }
  
}


// MARK: - UITableViewDelegate protocol
extension ForecastContentViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}


// MARK: - Actions
extension ForecastContentViewController {
  
  @objc func measuringSystemDidSwitch(_ notification: NSNotification) {
    guard let segmentedControl = notification.userInfo?["SegmentedControl"] as? SegmentedControl else { return }
    MeasuringSystem.isMetric = (segmentedControl.selectedIndex == 0 ? false : true)
    fetchWeatherForecast()
  }
  
  @objc func refreshButtonDidTap(_ notification: NSNotification) {
    fetchWeatherForecast()
  }
  
}
