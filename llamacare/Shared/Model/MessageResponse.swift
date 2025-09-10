//
//  MessageResponse.swift
//  Vocalove
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

struct MessageResponse: Decodable, Equatable, Error {
    let message: String
}

extension Error {
    var asErrorResponse: MessageResponse? {
        self as? MessageResponse
    }
}
