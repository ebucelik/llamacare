//
//  OpenRouterMessage.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 09.09.25.
//

public struct OpenRouterMessage: Codable, Equatable {
    public struct Message: Codable, Hashable {
        let role: String
        let content: String
        let refusal: String?
        let reasoning: String?

        public init(
            role: String = "user",
            content: String,
            refusal: String? = nil,
            reasoning: String? = nil
        ) {
            self.role = role
            self.content = content
            self.refusal = refusal
            self.reasoning = reasoning
        }
    }

    let model: String
    let messages: [Message]

    public init(
        model: String = "deepseek/deepseek-chat-v3.1:free",
        messages: [Message]
    ) {
        self.model = model
        self.messages = messages
    }
}
