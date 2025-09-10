//
//  OpenRouterCall.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 09.09.25.
//

import Foundation

struct OpenRouterCall: Call {
    typealias Parser = OpenRouterResponse

    var deployment: Deployment = Deployment.ai
    var ressource: String = ""
    var httpMethod: HttpMethod = .POST
    var body: Data?

    init(openRouterMessage: OpenRouterMessage) {
        do {
            body = try JSONEncoder().encode(openRouterMessage)
        } catch {
            print("Not decodable")
        }
    }
}
