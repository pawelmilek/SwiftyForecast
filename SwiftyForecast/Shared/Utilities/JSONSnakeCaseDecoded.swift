//
//  JSONSnakeCaseDecoded.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 5/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

final class JSONSnakeCaseDecoded: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }

    override func decode<T>(_ type: T.Type, from data: Data) -> T where T: Decodable {
        do {
            let result = try super.decode(type, from: data)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
