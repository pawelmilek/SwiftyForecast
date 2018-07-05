//
//  CurrentForecastView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 03/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

final class CurrentForecastView: UIView {
  @IBOutlet private var contentView: UIView!
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  
  @IBOutlet private weak var expandCollapseButton: UIButton!
  @IBOutlet private weak var windView: ConditionView!
  @IBOutlet private weak var humidityView: ConditionView!
  @IBOutlet private weak var hourlyCollectionView: UICollectionView!
  
  @IBOutlet weak var moreDetailsViewConstraint: NSLayoutConstraint!
  
  private var viewDidExpand = false
  weak var delegate: CurrentForecastViewDelegate?
  
  var currentForecast: CurrentForecast? {
    didSet {
      guard let currentForecast = currentForecast else { return }
      
      let icon = ConditionFontIcon.make(icon: currentForecast.icon, font: 90)
      iconLabel.attributedText = icon?.attributedIcon
      dateLabel.text = "\(currentForecast.time.weekday), \(currentForecast.time.longDayMonth)".uppercased()
      temperatureLabel.text = currentForecast.temperatureFormatted
      
      
      windView.configurate(condition: UIImage(named: "wind_indicator")!, value: "\(currentForecast.windSpeed)")
      humidityView.configurate(condition: UIImage(named: "humidity_indicator")!, value: "\(currentForecast.humidity)")
    }
  }
  
  var hourlyForecast: HourlyForecast? {
    didSet {
      guard let _ = hourlyForecast else { return }
      hourlyCollectionView.reloadData()
    }
  }

  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupStyle()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
    setupStyle()
  }
}


// MARK: ViewSetupable protocol
extension CurrentForecastView: ViewSetupable {
  
  func setup() {
    let nibName = CurrentForecastView.nibName
    Bundle.main.loadNibNamed(nibName, owner: self, options: [:])
    
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  
    contentView.backgroundColor = .red
    contentView.layer.cornerRadius = 15
    layer.cornerRadius = 15
    contentView.clipsToBounds = true
    clipsToBounds = true
    
    moreDetailsViewConstraint.constant = 0
    
    
    setCollectionView()
  }
  
  func setupStyle() {
    dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    dateLabel.textColor = .white
    dateLabel.textAlignment = .center
    
    iconLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
    iconLabel.textColor = .white
    iconLabel.textAlignment = .center
    
    temperatureLabel.font = UIFont.systemFont(ofSize: 90, weight: .bold)
    temperatureLabel.textColor = .white
    temperatureLabel.textAlignment = .center
  }
  
}


// MARK: - ViewSetupable protocol
private extension CurrentForecastView {
  
  func setCollectionView() {
    hourlyCollectionView.register(cellClass: HourlyForecastCollectionViewCell.self)
    hourlyCollectionView.dataSource = self
    hourlyCollectionView.delegate = self
    hourlyCollectionView.showsVerticalScrollIndicator = false
    hourlyCollectionView.showsHorizontalScrollIndicator = true
    hourlyCollectionView.backgroundColor = .blue
  }
  
}


// MARK: - UICollectionViewDataSource protocol
extension CurrentForecastView: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyForecast?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.reuseIdentifier, for: indexPath) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
    cell.configurate(by: hourlyForecast?.data[indexPath.item])
    return cell
  }
  
}


// MARK: UICollectionViewDelegateFlowLayout protocol
extension CurrentForecastView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 75)
  }
  
}


// MARK: - Action
extension CurrentForecastView {
  
  @IBAction func expandCollapseButtonTapped(_ sender: UIButton) {
    viewDidExpand = !viewDidExpand
    
    if viewDidExpand {
      delegate?.currentForecastDidExpand()
    } else {
      delegate?.currentForecastDidCollapse()
    }
  }
  
}
