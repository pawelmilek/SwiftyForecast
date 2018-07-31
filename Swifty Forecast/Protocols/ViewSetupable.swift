//
//  ViewSetupable.swift
//  DVBChart
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation

@objc protocol ViewSetupable: class {
  func setup()
  @objc optional func setupStyle()
  @objc optional func setupLayout()
}
