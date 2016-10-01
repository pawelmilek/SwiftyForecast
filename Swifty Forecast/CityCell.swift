//
//  CityCell.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import LatoFont


class CityCell: UITableViewCell, CustomViewSetupable {
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var city: City? {
        didSet {
            guard let city = self.city else { return }
            self.cityNameLabel.text = "\(city.name), \(city.country)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupStyle()
    }
}



// MARK: CustomViewSetupable
extension CityCell {
    
    func setup() {}
    
    func setupStyle() {
        self.backgroundColor = .clear
        
        self.cityNameLabel.font = UIFont.latoLightFont(ofSize: 18) //latoFont(ofSize: 18)
        self.cityNameLabel.textColor = .white
        self.cityNameLabel.textAlignment = .left
    }
    
    func renderView() {}
}
