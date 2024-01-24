//
//  JSONFileLoader.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

enum JSONFileLoader {

    static func loadFile(with name: String) throws -> Data {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            throw FileLoaderError.fileNotFound(name: name)
        }

        do {
            let pathURL = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: pathURL)
            return data

        } catch {
            throw FileLoaderError.fileNotFound(name: name)
        }
    }

}
