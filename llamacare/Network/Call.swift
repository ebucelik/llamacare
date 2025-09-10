//
//  Call.swift
//  Vocalove
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

protocol Call {
    associatedtype Parser: Decodable & Equatable

    var ressource: String { get }
    var deployment: Deployment { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var body: Data? { get }
    var parameters: [String: Any]? { get }
    var mediaData: (Data, FormData.DataType)? { get }
}

extension Call {
    var path: String { "\(deployment.rawValue)" + ressource }
    var body: Data? { nil }
    var parameters: [String: Any]? { nil }
    var mediaData: (Data, FormData.DataType)? { nil }
}

public enum Deployment {
    case dev(String)
    case prod(String)
    case ai

    var rawValue: String {
        switch self {
        case .dev(let port):
            return "http://127.0.0.1:\(port)/api/"
        case .prod(let port):
            return "http://85.215.128.216:\(port)/api/"
        case .ai:
            return "https://openrouter.ai/api/v1/chat/completions"
        }
    }
}
