//
//  APIError.swift
//  Vocalove
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

enum APIError: Error, Equatable {
    case decoding
    case response
    case invalidRequest
    case invalidUrl
    case requestFailed(Error)
    case unauthorized
    case general
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.decoding, .decoding):
            return true

        case (.response, .response):
            return true

        case (.invalidRequest, .invalidRequest):
            return true

        case (.invalidUrl, .invalidUrl):
            return true

        case (.requestFailed, .requestFailed):
            return true

        case (.unauthorized, .unauthorized):
            return true

        case (.general, .general):
            return true

        default:
            return false
        }
    }
}
