//
//  ResultType.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

enum ResultType<T, E> where E: Error {
  case success(T)
  case failure(E)
}
