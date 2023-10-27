//
//  JSONParser.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct JSONParser<M> where M: Decodable {

    static func parse(_ data: Data) -> M {
        do {
            let decodedData = try JSONDecoder().decode(M.self, from: data)
            return decodedData

        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
