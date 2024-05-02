import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        decoder: JSONDecoder,
        responseModel: T.Type
    ) async throws -> T
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        decoder: JSONDecoder,
        responseModel: T.Type
    ) async throws -> T {
        guard let url = endpoint.url else {
            throw RequestError.invalidURL(url: endpoint.url?.absoluteString ?? "unknown")
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if !endpoint.parameters.isEmpty {
            request = request.encode(with: endpoint.parameters)
        }

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.response
            }

            switch response.statusCode {
            case 200...226:
                guard let decodedResponse = try? decoder.decode(responseModel, from: data) else {
                    throw RequestError.decode
                }
                return decodedResponse

            case 400...451:
                throw RequestError.client(statusCode: response.statusCode)

            default:
                throw RequestError.unknown(statusCode: response.statusCode)
            }

        } catch {
            throw error
        }
    }
}
