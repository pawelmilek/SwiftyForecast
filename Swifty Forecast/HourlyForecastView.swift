//
//  HourlyForecastView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 03/10/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import Cartography


class HourlyForecastView: UIView, CustomViewLayoutSetupable, CustomViewSetupable {
    fileprivate var hourlyScrollView = UIScrollView()
    fileprivate var hourCells = [HourForecastView]()
    var isConstraints = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.setupStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



// MARK: Update Constraints
extension HourlyForecastView {
    
    override func updateConstraints() {
        if self.isConstraints {
            super.updateConstraints()
            return
        }
        
        self.setupLayout()
        
        super.updateConstraints()
        self.isConstraints = true
    }
}



// MAKR: CustomViewLayoutSetupable
extension HourlyForecastView {
    
    func setupLayout() {
        func setViewConstrain() {
            constrain(self) { view in
                view.height == 100
                return
            }
        }
     
        
        func setHourlyScrollViewConstrains() {
            constrain(self.hourlyScrollView) { view in
                view.top == view.superview!.top
                view.bottom == view.superview!.bottom
                view.left == view.superview!.left
                view.right == view.superview!.right
            }
        }
        
        func setHourlyForecastCellsConstrains() {
            constrain(hourCells.first!) { view in
                view.left == view.superview!.left
            }
            
            constrain(hourCells.last!) { view in
                view.right == view.superview!.right
            }
            
            
            
            for index in 1..<hourCells.count {
                let previousCell = hourCells[index - 1]
                let cell = hourCells[index]
                
                constrain(previousCell, cell) { view, view2 in
                    view.right == view2.left + 5
                }
            }
            
            for cell in hourCells {
                constrain(cell) { view in
                    view.width == view.height
                    view.height == view.superview!.height
                    view.top == view.superview!.top
                }
            }
        }
        
        setViewConstrain()
        setHourlyScrollViewConstrains()
        setHourlyForecastCellsConstrains()
    }
}



// MARK: CustomViewSetupable
extension HourlyForecastView {
    
    // Create cells and add them to scrollView
    func setup() {
        for _ in 0..<ConstantValue.numberOfHours {
            let cell = HourForecastView(frame: CGRect.zero)
            self.hourCells.append(cell)
            self.hourlyScrollView.addSubview(cell)
        }
        
        self.hourlyScrollView.showsVerticalScrollIndicator = false
        self.hourlyScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.hourlyScrollView)
        
    }
    
    func setupStyle() {
        func setBorders() {
            let width: CGFloat = 1
            let borderColor = UIColor.black.cgColor
            
            self.layer.borderWidth = width
            self.layer.borderColor = borderColor
        }
        
        setBorders()
    }
    
    func render() {
        for nextCell in self.hourCells {
            nextCell.render()
        }
    }
    
    func renderView(weathers: [Weather]) {
        
    }
}
