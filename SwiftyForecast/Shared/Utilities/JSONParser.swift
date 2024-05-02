//
//  JSONParser.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

final class JSONDecodedDecorator: JSONDecoder {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func decode<M>(_ type: M.Type, data: Data) -> M where M: Decodable {
        do {
            let decodedData = try decoder.decode(M.self, from: data)
            return decodedData

        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

struct JSONParser<M> where M: Decodable {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func parse(_ data: Data) -> M {
        do {
            let decodedData = try decoder.decode(M.self, from: data)

            let decode = JSONDecodedDecorator(decoder: decoder)
            let result = decode.decode(M.self, data: data)
//            decode.decode<CurrentWeatherResponse.Self>(data)
            return decodedData

        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
