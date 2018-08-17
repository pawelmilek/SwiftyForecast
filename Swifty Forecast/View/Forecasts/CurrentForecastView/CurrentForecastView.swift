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
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var windView: ConditionView!
  @IBOutlet private weak var humidityView: ConditionView!
  @IBOutlet private weak var hourlyCollectionView: UICollectionView!
  @IBOutlet private weak var moreDetailsView: UIView!
  @IBOutlet weak var moreDetailsViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var stackViewBottomToMoreDetailsTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var stackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint!
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(named: "swifty_background")
    imageView.layer.masksToBounds = true
    imageView.frame = contentView.bounds
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return imageView
  }()
  
  
  private var viewDidExpand = false
  weak var delegate: CurrentForecastViewDelegate?
  private var currentForecast: CurrentForecast?
  private var hourlyForecast: HourlyForecast?
  
  
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
    loadAndAddSubviews()
    setShadowForBaseView()
    setRoundedCornersForContentView()
    setCollectionView()
    addTapGestureRecognizer()
    
    configure(current: .none, at: .none)
    configure(hourly: .none)
  }
  
  func setupStyle() {
    iconLabel.textColor = .white
    iconLabel.textAlignment = .center
    
    dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
    dateLabel.textColor = .white
    dateLabel.textAlignment = .center
    
    cityNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
    cityNameLabel.textColor = .white
    cityNameLabel.textAlignment = .center
    
    temperatureLabel.font = UIFont.systemFont(ofSize: 90, weight: .bold)
    temperatureLabel.textColor = .white
    temperatureLabel.textAlignment = .center
    
    moreDetailsView.backgroundColor = .clear
    hourlyCollectionView.backgroundColor = .clear
  }
  
}


// MARK: - Set bottom shadow
private extension CurrentForecastView {
  
  func loadAndAddSubviews() {
    let nibName = CurrentForecastView.nibName
    Bundle.main.loadNibNamed(nibName, owner: self, options: [:])
    
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    contentView.addSubview(backgroundImageView)
    contentView.sendSubview(toBack: backgroundImageView)
  }
  
}


// MARK: - Set bottom shadow
private extension CurrentForecastView {
  
  func setShadowForBaseView() {
    backgroundColor = .clear
    layer.shadowColor = UIColor.red.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 5)
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 10
    layer.masksToBounds = false
  }
  
  func setRoundedCornersForContentView() {
    contentView.layer.cornerRadius = 15
    contentView.layer.masksToBounds = true
  }
}


// MARK: - Set collection view
private extension CurrentForecastView {
  
  func setCollectionView() {
    hourlyCollectionView.register(cellClass: HourlyForecastCollectionViewCell.self)
    hourlyCollectionView.dataSource = self
    hourlyCollectionView.delegate = self
    hourlyCollectionView.showsVerticalScrollIndicator = false
    hourlyCollectionView.showsHorizontalScrollIndicator = true
    hourlyCollectionView.showsHorizontalScrollIndicator = false
  }
  
}



// MARK: - Private - Add tap gesture recognizer
private extension CurrentForecastView {
  
  func addTapGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler(_:)))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    
    addGestureRecognizer(tapGestureRecognizer)
    isUserInteractionEnabled = true
  }
  
}


// MARK: - Configure current forecast
extension CurrentForecastView {
  
  func configure(current forecast: CurrentForecast?, at city: City?) {
    currentForecast = forecast
    
    if let forecast = forecast {
      let icon = ConditionFontIcon.make(icon: forecast.icon, font: 100)
      iconLabel.attributedText = icon?.attributedIcon
      dateLabel.text = "\(forecast.date.weekday), \(forecast.date.longDayMonth)".uppercased()
      cityNameLabel.text = city?.name
      temperatureLabel.text = forecast.temperatureFormatted

      windView.configure(condition: .strongWind, value: "\(forecast.windSpeed)")
      humidityView.configure(condition: .humidity, value: "\(Int(forecast.humidity * 100))")
      iconLabel.alpha = 1
      dateLabel.alpha = 1
      cityNameLabel.alpha = 1
      temperatureLabel.alpha = 1
      windView.alpha = 1
      humidityView.alpha = 1
      
    } else {
      iconLabel.alpha = 0
      dateLabel.alpha = 0
      cityNameLabel.alpha = 0
      temperatureLabel.alpha = 0
      windView.alpha = 0
      humidityView.alpha = 0
    }
  }
  
  func configure(hourly forecast: HourlyForecast?) {
    hourlyForecast = forecast
    
    if let _ = forecast {
      hourlyCollectionView.reloadData()
      moreDetailsView.alpha = 1
      
    } else {
      moreDetailsView.alpha = 0
    }
  }
  
}


// MARK: - Animate labels
extension CurrentForecastView {
  
  func animateLabelsScaling() {
    if UIScreen.PhoneModel.isPhoneSE {
      iconLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      dateLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      cityNameLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      temperatureLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      
    } else if UIScreen.PhoneModel.isPhone8 {
      iconLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      dateLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      cityNameLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      temperatureLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      
    } else {
      iconLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
      dateLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
      cityNameLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
      temperatureLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
    }

  }
  
  func animateLabelsIdentity() {
    iconLabel.transform = .identity
    dateLabel.transform = .identity
    cityNameLabel.transform = .identity
    temperatureLabel.transform = .identity
  }
  
}


// MARK: - UICollectionViewDataSource protocol
extension CurrentForecastView: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyForecast?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.reuseIdentifier, for: indexPath) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
    cell.configure(by: hourlyForecast?.data[indexPath.item])
    return cell
  }
  
}


// MARK: UICollectionViewDelegateFlowLayout protocol
extension CurrentForecastView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 85)
  }
  
}


// MARK: - Action
extension CurrentForecastView {
  
  @objc func tapGestureHandler(_ sender: UITapGestureRecognizer) {
    viewDidExpand = !viewDidExpand
    
    if viewDidExpand {
      delegate?.currentForecastDidExpandAnimation()

    } else {
      delegate?.currentForecastDidCollapseAnimation()
    }
  }
  
}
