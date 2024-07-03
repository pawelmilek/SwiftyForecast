//
//  NetworkResourceFactory.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol NetworkResourceFactoryProtocol {
    func make(by type: NetworkResourceType) -> NetworkResourceProtocol
}

struct NetworkResourceFactory: NetworkResourceFactoryProtocol {
    func make(by type: NetworkResourceType) -> NetworkResourceProtocol {
        NetworkResource(stringURL: type.stringURL)
    }
}
