//
//  NewCityController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import Foundation
import Cartography



class NewCityController: UIViewController, UITextFieldDelegate, CustomViewLayoutSetupable, ViewSetupable {
  private var backgroundImageView: UIImageView! = nil
  @IBOutlet weak var cityName: UITextField!
  @IBOutlet weak var countryName: UITextField!
  weak var delegate: NewCityControllerDelegate? = nil
  var isConstraints = true
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setup()
    self.setupLayout()
    self.setupStyle()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.cityName.becomeFirstResponder()
  }
}


// MARK: - CustomViewLayoutSetupable
extension NewCityController {
  
  func setupLayout() {
    let horizontalMerge: CGFloat = 8
    let verticalMerge: CGFloat = 16
    
    func setCityNameTextFieldConstrains() {
      constrain(self.cityName) { view in
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let topMerge = statusBarHeight + navigationBarHeight + verticalMerge
        
        view.top == view.superview!.top + topMerge
        view.left == view.superview!.left + horizontalMerge
        view.right == view.superview!.right - horizontalMerge
      }
    }
    
    func setCountryNameTextFieldConstrains() {
      constrain(self.countryName, self.cityName) { view, view2 in
        view.top == view2.bottom + (verticalMerge - horizontalMerge)
        view.left == view2.left
        view.right == view2.right
      }
    }
    
    
    setCityNameTextFieldConstrains()
    setCountryNameTextFieldConstrains()
  }
}


// MARK: - CustomViewSetupable
extension NewCityController {
  func setup() {
    func setupBackgroundImageView() {
      self.backgroundImageView = UIImageView(frame: self.view.bounds)
      self.backgroundImageView.contentMode = .scaleAspectFill
      self.backgroundImageView.clipsToBounds = true
      self.backgroundImageView.image = UIImage(named: "background-default.png")
      self.view.insertSubview(self.backgroundImageView, at: 0)
    }
    
    func setTextFieldDelegates() {
      self.cityName.delegate = self
      self.countryName.delegate = self
    }
    
    
    setTextFieldDelegates()
    setupBackgroundImageView()
    
  }
  
  func setupStyle() {
    self.cityName.textColor = .orange
    self.countryName.textColor = .orange
  }
}


// MARK: - UITextFieldDelegate
extension NewCityController {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    if textField == self.cityName {
      self.countryName.becomeFirstResponder()
    }
    
    return true
  }
}


// MAKR: Actions
private extension NewCityController {
  
  @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
    self.hideKeyboard()
    self.delegate?.newContactViewControllerDidCancel(self)
  }
  
  
  @IBAction func saveTapped(_ sender: UIBarButtonItem) {
    func isCityNameNilOrEmpty() -> Bool {
      guard let name = self.cityName.text else { return true }
      return (name.trimmingCharacters(in: .whitespaces) == "") ? true : false
    }
    
    func isCountryNameNilOrEmpty() -> Bool {
      guard let country = self.countryName.text else { return true }
      return (country.trimmingCharacters(in: .whitespaces) == "") ? true : false
    }
    
    
    if isCityNameNilOrEmpty() {
      AlertViewPresenter.shared.presentError(withMessage: "Check City Name text field.")
      return
    }
    
    if isCountryNameNilOrEmpty() {
      AlertViewPresenter.shared.presentError(withMessage: "Check Country Name text field.")
      return
    }
    
    self.hideKeyboard()
    
    let trimName = self.cityName.text!.trimmingCharacters(in: .whitespaces)
    let trimCountry = self.countryName.text!.trimmingCharacters(in: .whitespaces)
    
    Geocoder.findCoordinate(by: "\(trimName), \(trimCountry)") { coord in
      //print("\(coord)")
      let newCity = City(name: trimName, country: trimCountry, coordinate: coord)
      self.delegate?.newCityControllerDidAdd(self, city: newCity)
    }
  }
}


// MAKR: Close Keyboard
private extension NewCityController {
  
  func hideKeyboard() {
    for view in view.subviews {
      if view.isFirstResponder {
        view.resignFirstResponder()
      }
    }
  }
  
}
