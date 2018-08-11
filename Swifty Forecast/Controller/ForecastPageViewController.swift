//
//  ForecastPageViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/08/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

class ForecastPageViewController: UIPageViewController {
  private lazy var measuringSystemSegmentedControl: SegmentedControl = {
    let segmentedControl = SegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    segmentedControl.items = ["\u{00B0}" + "F", "\u{00B0}" + "C"]
    segmentedControl.font = UIFont(name: "AvenirNext-Bold", size: 14)
    segmentedControl.borderWidth = 1.0
    segmentedControl.selectedLabelColor = .white
    segmentedControl.unselectedLabelColor = .blackShade
    segmentedControl.borderColor = .blackShade
    segmentedControl.thumbColor = .blackShade
    segmentedControl.selectedIndex = 0
    segmentedControl.backgroundColor = .clear
    segmentedControl.addTarget(self, action: #selector(measuringSystemSwitched(_:)), for: .valueChanged)
    return segmentedControl
  }()
  
  
  private var cities: [City] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    setupStyle()
  }
  
  
  @objc func measuringSystemSwitched(_ sender: SegmentedControl) {
    MeasuringSystem.isMetric = (sender.selectedIndex == 0 ? false : true)
//    fetchWeatherForecast()
  }
  
}


// MARK: - ViewSetupable protocol
extension ForecastPageViewController: ViewSetupable {
  
  func setup() {
    fetchCities()
    setDataSource()
    setMetricSystemSegmentedControl()
    setFirstViewController()
  }
  
  func setupStyle() {
    view.backgroundColor = .white
    
    
  }
  
}


// MARK: - Private - fetch cities
private extension ForecastPageViewController {
  
  func fetchCities() {
    let fetchRequest = City.createFetchRequest()
    
    do {
      cities = try CoreDataStackHelper.shared.mainContext.fetch(fetchRequest)
    } catch {
      CoreDataError.couldNotFetch.handle()
    }
  }
 
}


// MARK: - Private - Set metric system segmented control
private extension ForecastPageViewController {
  
  func setMetricSystemSegmentedControl() {
    navigationItem.titleView = measuringSystemSegmentedControl
  }
  
}


// MARK: - Private - Set dataSource and first ViewController
private extension ForecastPageViewController {
  
  func setDataSource() {
    self.dataSource = self
  }
  
  func setFirstViewController() {
    let vc = forecastViewController(at: 0)!
    let vcNavigationController = UINavigationController(rootViewController: vc)
    let forecastViewControllers: [UIViewController] = [vc]
    self.setViewControllers(forecastViewControllers, direction: .forward, animated: true)
  }
  
}


// MARK: - Private - fetch cities
private extension ForecastPageViewController {
  
  func forecastViewController(at index: Int) -> ForecastPageContentViewController? {
    guard cities.isEmpty == false || (index >= cities.count) == false else { return nil }
    let storyboard = UIStoryboard(storyboard: .main)
    let forecastVC = storyboard.instantiateViewController(ForecastPageContentViewController.self)
    forecastVC.pageIndex = index
    forecastVC.currentCityForecast = cities[index]
    return forecastVC
  }
  
  
  func index(of forecastPageContentViewController: ForecastPageContentViewController) -> Int {
    guard let city = forecastPageContentViewController.currentCityForecast else { return NSNotFound }
    return cities.firstIndex(of: city) ?? NSNotFound
  }
  
}


// MARK: - UIPageViewControllerDataSource protocol
extension ForecastPageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let forecastPageContentViewController = viewController as? ForecastPageContentViewController else { return nil }
    
    let indexOfViewController = index(of: forecastPageContentViewController)
    if  indexOfViewController == NSNotFound || indexOfViewController == 0 {
      return nil
    }

    return forecastViewController(at: indexOfViewController - 1)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let forecastPageContentViewController = viewController as? ForecastPageContentViewController else { return nil }
    
    let indexOfViewController = index(of: forecastPageContentViewController)
    if indexOfViewController == NSNotFound || (indexOfViewController + 1) == cities.count {
      return nil
    }
    
    return forecastViewController(at: indexOfViewController + 1)
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return cities.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let firstCity = cities.first, let firstViewControllerIndex = cities.firstIndex(of: firstCity) else { return 0 }
    return firstViewControllerIndex
  }
}
