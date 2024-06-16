//
//  Endpoint.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

typealias Header = [String: String]
typealias Body = [String: String]
typealias Parameters = [String: String]

protocol Endpoint {
    var url: URL? { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
    var header: Header? { get }
    var body: Body? { get }
}
