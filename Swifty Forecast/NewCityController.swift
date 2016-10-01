//
//  NewCityController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import CoreLocation



class NewCityController: UIViewController, UITextFieldDelegate, CustomViewLayoutSetupable, CustomViewSetupable {
    fileprivate var backgroundImageView: UIImageView! = nil
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var countryName: UITextField!
    weak var delegate: NewCityControllerDelegate? = nil
    var isConstraints = false
    
    
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


// MARK: CustomViewLayoutSetupable
extension NewCityController {
    func setupLayout() {
        // MARK: TODO
    }
}


// MARK: CustomViewSetupable
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


// MARK: UITextFieldDelegate
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
fileprivate extension NewCityController {
    
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
            AlertController.presentAlertWith(title: "New City", andMessage: "Check City Name text field.")
            return
        }
        
        if isCountryNameNilOrEmpty() {
            AlertController.presentAlertWith(title: "New City", andMessage: "Check Country Name text field.")
            return
        }
        
        self.hideKeyboard()
        
        let trimName = self.cityName.text!.trimmingCharacters(in: .whitespaces)
        let trimCountry = self.countryName.text!.trimmingCharacters(in: .whitespaces)
        
        Geocoder.getCoordinateFrom(address: "\(trimName), \(trimCountry)", completionBlock: { (coord) in
            //print("\(coord)")
            let newCity = City(name: trimName, country: trimCountry, latitude: coord.latitude, longitude: coord.longitude)
            self.delegate?.newCityControllerDidAdd(self, city: newCity)
        })
    }
}


// MAKR: Close Keyboard
fileprivate extension NewCityController {
    
    func hideKeyboard() {
        for view in view.subviews {
            if view.isFirstResponder {
                view.resignFirstResponder()
            }
        }
    }
    
}
