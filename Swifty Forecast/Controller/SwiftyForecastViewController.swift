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
  @IBOutlet weak var currentForecastView: CurrentForecastView!
  @IBOutlet weak var dailyForecastTableView: UITableView!
  
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
  
  private var collapsedCurrentForecastViewHeight: CGFloat!
  private var city: City?
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //    setupLayout()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    collapsedCurrentForecastViewHeight = currentForecastView.frame.size.height
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
    currentForecastView.delegate = self
    setMetricSystemSegmentedControl()
    setDailyForecastTableView()
  }
  
  
  func setupLayout() {}
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
    
    LocationProvider.shared.getCurrentLocation() { [weak self] cityLocation in
      let request = ForecastRequest.make(by: cityLocation)
      WebService.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
        switch response {
        case .success(let forecast):
          let currentCityCoord = Coordinate(latitude: forecast.latitude, longitude: forecast.longitude)
          
          Geocoder.findCity(at: currentCityCoord) { [weak self] city in
            DispatchQueue.main.async {
              self?.weatherForecast = WeatherForecast(city: city, currently: forecast.currently, hourly: forecast.hourly, daily: forecast.daily)
              ActivityIndicator.shared.stopAnimating()
            }
          }
          
        case .failure(let error):
          ActivityIndicator.shared.stopAnimating()
          error.handle()
        }
      })
    }
  }
  
}



// MARK: - topDistance
extension SwiftyForecastViewController: CurrentForecastViewDelegate {
  
  var topDistance: CGFloat {
    guard let navigationController = navigationController else { return 0 }
    let barHeight = navigationController.navigationBar.frame.height
    let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    return barHeight + statusBarHeight
  }
  
  
  func currentForecastDidExpand() {
    animateBouncingEffect()
    
    self.currentForecastView.moreDetailsView.alpha = 0
    let height = currentForecastView.frame.size.height + dailyForecastTableView.frame.size.height + 12
    
    UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
      self.currentForecastView.frame.size.height = height

    }, completion: { isFinished in
      if isFinished {
        self.currentForecastView.bottomAnchor.constraint(equalTo: self.dailyForecastTableView.bottomAnchor, constant: 0).isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
          self.currentForecastView.moreDetailsViewBottomConstraint.constant = 0
          self.currentForecastView.moreDetailsView.alpha = 1
        })
      }
    })
  }
  
  func currentForecastDidCollapse() {
    self.currentForecastView.moreDetailsView.alpha = 0
    let height = self.currentForecastView.frame.size.height
    self.currentForecastView.bottomAnchor.constraint(equalTo: self.dailyForecastTableView.bottomAnchor, constant: 0).isActive = false
    
    UIView.animate(withDuration: 0.38, delay: 0, options: .curveEaseIn, animations: {
      self.currentForecastView.moreDetailsViewBottomConstraint.constant = height
      
    }, completion: { isFinished in
      if isFinished {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
          
          self.currentForecastView.frame.size.height = self.collapsedCurrentForecastViewHeight
          
        }, completion: { isFinished in
          
        })
      }
    })
  }
  
}


// MARK: - CityListSelectDelegate protocol
extension SwiftyForecastViewController: CityListSelectDelegate {
  
  func cityListDidSelect(city: City) {
    self.city = city
  }
}


// MARK: - animateBouncingEffect
extension SwiftyForecastViewController {
 
  func animateBouncingEffect() {
    currentForecastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
    UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
      self.currentForecastView.transform = CGAffineTransform.identity
    }, completion: { isFinished in
      if isFinished {
        
      }
    })
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
