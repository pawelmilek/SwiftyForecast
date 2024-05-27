//
//  DecodedPlist.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct DecodedPlist {
    private let file: ResourceFile
    private let decoder: PropertyListDecoder

    init(name: String, bundle: Bundle) {
        self.init(
            file: ResourceFile(name: name, fileExtension: "plist", bundle: bundle),
            decoder: PropertyListDecoder()
        )
    }

    init(file: ResourceFile, decoder: PropertyListDecoder) {
        self.file = file
        self.decoder = decoder
    }

    func plist<T: Decodable>(ofType: T.Type) throws -> T {
        let plistData = try file.data()
        let plist = try decoder.decode(ofType, from: plistData)
        return plist
    }
}
