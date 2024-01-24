//
//  RequestError.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

enum RequestError: Error {
    case invalidURL(url: String)
    case response
    case decode
    case client(statusCode: Int)
    case unknown(statusCode: Int)
}

// MARK: - Error description
extension RequestError {

    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return url

        case .response:
            return "Server cannot or will not process a request."

        case .decode:
            return "Server cannot or will not process due to invalid decode data."

        case .client(let code):
            return "Server cannot or will not process the request due to a client error code \(code)."

        case .unknown(let code):
            return "Server cannot or will not process due to an unknown error code \(code)."

        }
    }

}
