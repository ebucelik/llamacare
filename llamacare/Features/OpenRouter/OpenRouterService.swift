//
//  OpenRouterService.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 10.09.25.
//

import ComposableArchitecture

protocol OpenRouterServiceProtocol {
    func sendMessage(openRouterMessage: OpenRouterMessage) async throws -> OpenRouterResponse
}

class OpenRouterService: APIClient, OpenRouterServiceProtocol {
    func sendMessage(openRouterMessage: OpenRouterMessage) async throws -> OpenRouterResponse {
        try await start(
            call: OpenRouterCall(
                openRouterMessage: openRouterMessage
            )
        )
    }
}

class NonInjectedOpenRouterService: OpenRouterServiceProtocol {
    func sendMessage(openRouterMessage: OpenRouterMessage) async throws -> OpenRouterResponse {
        fatalError("Not injected")
    }
}

enum OpenRouterServiceKey: DependencyKey {
    static let liveValue: any OpenRouterServiceProtocol = NonInjectedOpenRouterService()
    static let testValue: any OpenRouterServiceProtocol = NonInjectedOpenRouterService()
}

extension DependencyValues {
    var openRouterService: OpenRouterServiceProtocol {
        get { self[OpenRouterServiceKey.self] }
        set { self[OpenRouterServiceKey.self] = newValue }
    }
}
