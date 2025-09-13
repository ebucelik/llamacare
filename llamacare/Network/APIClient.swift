//
//  APIClient.swift
//  Vocalove
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation
import SwiftHelper

class APIClient: NSObject, URLSessionTaskDelegate {
    func start<C: Call>(call: C) async throws -> C.Parser {
        guard var urlComponents = URLComponents(string: call.path) else { throw APIError.invalidUrl }

        if let parameters = call.parameters {
            urlComponents.queryItems = parameters.map { parameter in
                URLQueryItem(
                    name: parameter.key,
                    value: "\(parameter.value)"
                )
            }
        }

        guard let url = urlComponents.url else { throw APIError.invalidUrl }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = call.httpMethod.rawValue
        urlRequest.httpBody = call.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if call.path.contains("openrouter.ai") {
            urlRequest.setValue("Bearer \(Secrets.openRouterAPIKey)", forHTTPHeaderField: "Authorization")
        }

        return try await handleResponse(
            with: urlRequest,
            url: url,
            call: call
        )
    }

    private func isStatusCodeOk(code: Int) -> Bool {
        (200...399).contains(code)
    }

    private func isStatusCodeNotOk(code: Int) -> Bool {
        (400...599).contains(code)
    }

    private func handleResponse<C: Call>(
        with urlRequest: URLRequest,
        url: URL,
        call: C
    ) async throws -> C.Parser {
        let response = try await URLSession.shared.data(for: urlRequest)

        guard let httpUrlResponse = response.1 as? HTTPURLResponse else { throw APIError.response }

        if isStatusCodeOk(code: httpUrlResponse.statusCode) {
#if DEBUG
            print(String(data: response.0, encoding: .utf8) ?? "")
#endif
            return try JSONDecoder().decode(C.Parser.self, from: response.0)
        } else if isStatusCodeNotOk(code: httpUrlResponse.statusCode) {
            if httpUrlResponse.statusCode == 401 {
                throw APIError.unauthorized
            } else {
                var errorResponse: MessageResponse = .init(message: "")

                do {
                    errorResponse = try JSONDecoder().decode(MessageResponse.self, from: response.0)
                } catch {
                    throw APIError.decoding
                }

                throw APIError.requestFailed(errorResponse)
            }
        }

        throw APIError.general
    }
}
