//
//  SwiftyForecastViewController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

class SwiftyForecastViewController: UIViewController {
  @IBOutlet private weak var currentForecastView: CurrentForecastView!
  @IBOutlet private weak var dailyForecastTableView: UITableView!
  
  private lazy var measuringSystemSegmentedControl: SegmentedControl = {
    let segmentedControl = SegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    segmentedControl.items = ["℉", "℃"]
    segmentedControl.font = UIFont(name: "AvenirNext-Bold", size: 14)
    segmentedControl.borderWidth = 1.0
    segmentedControl.selectedLabelColor = .white
    segmentedControl.unselectedLabelColor = .blackShade
    segmentedControl.borderColor = .blackShade
    segmentedControl.thumbColor = .blackShade
    segmentedControl.selectedIndex = 0
    segmentedControl.backgroundColor = .clear
    segmentedControl.addTarget(self, action: #selector(SwiftyForecastViewController.measuringSystemSwitched(_:)), for: .valueChanged)
    return segmentedControl
  }()
  
  
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  private var citysForecast: City? {
    didSet {
      guard let citysForecast = citysForecast else { return }
      fetchWeatherForecast(for: citysForecast)
    }
  }
  
  var weatherForecast: WeatherForecast? {
    didSet {
      guard let weatherForecast = weatherForecast else { return }
      currentForecastView.configure(current: weatherForecast.currently)
      currentForecastView.configure(hourly: weatherForecast.hourly)
      dailyForecastTableView.reloadData()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    fetchWeatherForecast()
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


// MARK: - ViewSetupable protocol
extension SwiftyForecastViewController: ViewSetupable {
  
  func setup() {
    setCurrentForecastViewDelegate()
    setSupportingCurrentForecastViewConstraints()
    setMetricSystemSegmentedControl()
    setDailyForecastTableView()
  }
  
}


// MARK: - Private - Set currentForecastView delegate
private extension SwiftyForecastViewController {
  
  func setCurrentForecastViewDelegate() {
    currentForecastView.delegate = self
  }
  
}


// MARK: - Private - Set currentForecastView constraints
private extension SwiftyForecastViewController {
  
  func setSupportingCurrentForecastViewConstraints() {
    currentForecastViewMoreDetailsViewBottomConstraint = currentForecastView.moreDetailsViewBottomConstraint
    dailyForecastTableViewBottomConstraint = currentForecastView.bottomAnchor.constraint(equalTo: self.dailyForecastTableView.bottomAnchor, constant: 0)
  }
}


// MARK: - Private - Set metric system segmented control
private extension SwiftyForecastViewController {
  
  func setMetricSystemSegmentedControl() {
    navigationItem.titleView = measuringSystemSegmentedControl
  }
  
}


// MARK: - Private - Set daily Forecast TableView
private extension SwiftyForecastViewController {
  
  func setDailyForecastTableView() {
    dailyForecastTableView.register(cellClass: DailyForecastTableViewCell.self)
    dailyForecastTableView.dataSource = self
    dailyForecastTableView.showsVerticalScrollIndicator = false
    dailyForecastTableView.allowsSelection = false
    dailyForecastTableView.rowHeight = UITableViewAutomaticDimension
    dailyForecastTableView.estimatedRowHeight = 85
    dailyForecastTableView.backgroundColor = .white
    dailyForecastTableView.separatorStyle = .none
    dailyForecastTableView.tableFooterView = UIView()
  }
  
}


// MAKR: Fetch weather forecast
private extension SwiftyForecastViewController {
  
  func fetchWeatherForecast() {
    ActivityIndicator.shared.startAnimating(at: self.view)
    
    GooglePlacesHelper.getCurrentPlace() { (place, error) in
      if let error = error {
        AlertViewPresenter.shared.presentError(withMessage: "Google Places error: \(error.localizedDescription)")
        return
      }
      
      if let place = place {
        let coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let request = ForecastRequest.make(by: coordinate)
        
        WebService.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
          switch response {
          case .success(let forecast):
            DispatchQueue.main.async {
              let city = City(addressComponents: place.addressComponents, coordinate: coordinate)
              self.weatherForecast = WeatherForecast(city: city, forecastResponse: forecast)
              ActivityIndicator.shared.stopAnimating()
            }
            
          case .failure(let error):
            DispatchQueue.main.async {
              ActivityIndicator.shared.stopAnimating()
              error.handle()
            }
          }
        })
        
      } else {
        AlertViewPresenter.shared.presentError(withMessage: "Google Places error: No place found.")
      }
    }
  }
  
  
  func fetchWeatherForecast(for city: City) {
    ActivityIndicator.shared.startAnimating(at: self.view)
    
    let request = ForecastRequest.make(by: city.coordinate)
    WebService.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
      switch response {
      case .success(let forecast):
        DispatchQueue.main.async {
          self.weatherForecast = WeatherForecast(city: city, forecastResponse: forecast)
          ActivityIndicator.shared.stopAnimating()
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          ActivityIndicator.shared.stopAnimating()
          error.handle()
        }
      }
    })
  }
  
}


// MARK: - CurrentForecastViewDelegate protocol
extension SwiftyForecastViewController: CurrentForecastViewDelegate {
  
  func currentForecastDidExpandAnimation() {
    animateBouncingEffect()
    
    currentForecastViewMoreDetailsViewBottomConstraint?.constant = 0
    dailyForecastTableViewBottomConstraint?.isActive = true
    
    UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.currentForecastView.animateLabelsScaling()
      self.view.layoutIfNeeded()
    })
  }
  
  func currentForecastDidCollapseAnimation() {
    let height = currentForecastView.frame.size.height
    
    currentForecastViewMoreDetailsViewBottomConstraint?.constant = height
    dailyForecastTableViewBottomConstraint?.isActive = false
    
    UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
      self.currentForecastView.animateLabelsIdentity()
      self.view.layoutIfNeeded()
    })
  }
  
}


// MARK: - Private - animateBouncingEffect
private extension SwiftyForecastViewController {
  
  func animateBouncingEffect() {
    currentForecastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
    UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
      self.currentForecastView.transform = .identity
    })
  }
  
}


// MARK: - CityListTableViewControllerDelegate protocol
extension SwiftyForecastViewController: CityListTableViewControllerDelegate {
  
  func cityListController(_ cityListTableViewController: CityListTableViewController, didSelect city: City) {
    self.citysForecast = city
  }
  
}


// MARK: - UITableViewDataSource protcol
extension SwiftyForecastViewController: UITableViewDataSource {
  
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
