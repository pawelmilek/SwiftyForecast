//
//  ForecastPageContentViewController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ForecastPageContentViewController: UIViewController {
  @IBOutlet private weak var currentForecastView: CurrentForecastView!
  @IBOutlet private weak var dailyForecastTableView: UITableView!
  @IBOutlet private weak var pageControl: UIPageControl!
  
  private let sharedMOC = CoreDataStackHelper.shared
  
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  
  var currentCityForecast: City? {
    didSet {
      guard let currentCityForecast = currentCityForecast else { return }
      fetchWeatherForecast(for: currentCityForecast)
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
  
  var pageIndex: Int = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    fetchWeatherForecast()
  }
}


// MARK: - Preper For Seuge
extension ForecastPageContentViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier, identifier == SegueIdentifierType.showCityListSegue.rawValue else { return }
    guard let cityListVC = segue.destination as? ForecastCityListTableViewController else { return }
    
    cityListVC.delegate = self
  }
}


// MARK: - ViewSetupable protocol
extension ForecastPageContentViewController: ViewSetupable {
  
  func setup() {
    setCurrentForecastViewDelegate()
    setSupportingCurrentForecastViewConstraints()
    setDailyForecastTableView()
    setPageControl()
  }
  
}


// MARK: - Private - Set currentForecastView delegate
private extension ForecastPageContentViewController {
  
  func setCurrentForecastViewDelegate() {
    currentForecastView.delegate = self
  }
  
}


// MARK: - Private - Set currentForecastView constraints
private extension ForecastPageContentViewController {
  
  func setSupportingCurrentForecastViewConstraints() {
    currentForecastViewMoreDetailsViewBottomConstraint = currentForecastView.moreDetailsViewBottomConstraint
    dailyForecastTableViewBottomConstraint = currentForecastView.bottomAnchor.constraint(equalTo: self.dailyForecastTableView.bottomAnchor, constant: 0)
  }
}


// MARK: - Private - Set daily Forecast TableView
private extension ForecastPageContentViewController {
  
  func setDailyForecastTableView() {
    dailyForecastTableView.register(cellClass: DailyForecastTableViewCell.self)
    dailyForecastTableView.dataSource = self
    dailyForecastTableView.showsVerticalScrollIndicator = false
    dailyForecastTableView.allowsSelection = false
    dailyForecastTableView.rowHeight = UITableView.automaticDimension
    dailyForecastTableView.estimatedRowHeight = 85
    dailyForecastTableView.backgroundColor = .white
    dailyForecastTableView.separatorStyle = .none
    dailyForecastTableView.tableFooterView = UIView()
  }
  
}


// MARK: - Private - Set page control
private extension ForecastPageContentViewController {
  
  func setPageControl() {
    pageControl.currentPage = pageIndex
  }
}


// MAKR: Fetch weather forecast
private extension ForecastPageContentViewController {
  
  func fetchWeatherForecast() {
    if let currentCityForecast = currentCityForecast {
      fetchWeatherForecast(for: currentCityForecast)
    } else {
      fetchWeatherForecastForCurrentLocation()
    }
  }
  
  
  func fetchWeatherForecastForCurrentLocation() {
    ActivityIndicator.shared.startAnimating(at: view)
    
    GooglePlacesHelper.getCurrentPlace() { (place, error) in
      if let error = error {
        ActivityIndicator.shared.stopAnimating()
        AlertViewPresenter.shared.presentError(withMessage: "Google Places: \(error.localizedDescription)")
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
              let managedContex = self.sharedMOC.mainContext
              
              let unassociatedCity = City(place: place)
              self.weatherForecast = WeatherForecast(city: unassociatedCity, forecastResponse: forecast)
              
              if City.isDuplicate(city: unassociatedCity) == false {
                let _ = City(unassociatedObject: unassociatedCity, managedObjectContext: managedContex)
                do {
                  try managedContex.save()
                } catch {
                  CoreDataError.couldNotSave.handle()
                }
                
              } else {
                // TODO: Update exists record and save
                let request = City.createFetchRequest()
                let predicate = NSPredicate(format: "name == %@ AND country == %@ AND coordinate == %@", unassociatedCity.name, unassociatedCity.country, unassociatedCity.coordinate)
                request.predicate = predicate
                
                do {
                  let result = try managedContex.fetch(request)
                  result.forEach {
                    $0.coordinate = unassociatedCity.coordinate // update current forecast
                  }
                  
                  try managedContex.save()
                } catch {
                  CoreDataError.couldNotFetch.handle()
                }
              }
              
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
        ActivityIndicator.shared.stopAnimating()
        AlertViewPresenter.shared.presentError(withMessage: "Google Places: No place found.")
      }
    }
  }
  
  
  func fetchWeatherForecast(for city: City) {
    ActivityIndicator.shared.startAnimating(at: view)

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
extension ForecastPageContentViewController: CurrentForecastViewDelegate {
  
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


// MARK: - Private - Animate bouncing effect
private extension ForecastPageContentViewController {
  
  func animateBouncingEffect() {
    currentForecastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
    UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
      self.currentForecastView.transform = .identity
    })
  }
  
}


// MARK: - CityListTableViewControllerDelegate protocol
extension ForecastPageContentViewController: CityListTableViewControllerDelegate {
  
  func cityListController(_ cityListTableViewController: ForecastCityListTableViewController, didSelect city: City) {
    self.currentCityForecast = city
  }
  
}


// MARK: - UITableViewDataSource protcol
extension ForecastPageContentViewController: UITableViewDataSource {
  
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
extension ForecastPageContentViewController {
  
  @objc func measuringSystemSwitched(_ sender: SegmentedControl) {
    MeasuringSystem.isMetric = (sender.selectedIndex == 0 ? false : true)
    fetchWeatherForecast()
  }
  
  @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
    fetchWeatherForecast()
  }
  
}


// MARK: - TESTING!!
extension ForecastPageContentViewController {
  
  func clearStorage() {
    let managedObjectContext = sharedMOC.mainContext
    let cityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: City.entityName)
    let coordinateFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Coordinate.entityName)
    let cityBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: cityFetchRequest)
    let coordinateBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: coordinateFetchRequest)
    
    do {
      try managedObjectContext.execute(cityBatchDeleteRequest)
      try managedObjectContext.execute(coordinateBatchDeleteRequest)
      try managedObjectContext.save()
    } catch let error as NSError {
      print(error)
    }
  }
  
  
  func fetchFromStorage() -> [City]? {
    let managedObjectContext = sharedMOC.mainContext
    let fetchRequest = City.createFetchRequest()
    let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    let countrySortDescriptor = NSSortDescriptor(key: "country", ascending: true)
    fetchRequest.sortDescriptors = [nameSortDescriptor, countrySortDescriptor]
    do {
      let users = try managedObjectContext.fetch(fetchRequest)
      return users
    } catch let error {
      print(error)
      return nil
    }
  }
  
}
