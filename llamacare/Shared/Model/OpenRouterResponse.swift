//
//  OpenRouterResponse.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 09.09.25.
//

struct OpenRouterResponse: Codable, Equatable {
    struct Choice: Codable, Equatable {
        let logprobs: String?
        let finish_reason: String
        let native_finish_reason: String
        let index: Int
        let message: OpenRouterMessage.Message

        init(
            logprobs: String?,
            finish_reason: String,
            native_finish_reason: String,
            index: Int,
            message: OpenRouterMessage.Message
        ) {
            self.logprobs = logprobs
            self.finish_reason = finish_reason
            self.native_finish_reason = native_finish_reason
            self.index = index
            self.message = message
        }
    }

    struct Usage: Codable, Equatable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
        let prompt_tokens_details: String?

        init(
            prompt_tokens: Int,
            completion_tokens: Int,
            total_tokens: Int,
            prompt_tokens_details: String?
        ) {
            self.prompt_tokens = prompt_tokens
            self.completion_tokens = completion_tokens
            self.total_tokens = total_tokens
            self.prompt_tokens_details = prompt_tokens_details
        }
    }

    let id: String
    let provider: String
    let model: String
    let object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage

    init(
        id: String,
        provider: String,
        model: String,
        object: String,
        created: Int,
        choices: [Choice],
        usage: Usage
    ) {
        self.id = id
        self.provider = provider
        self.model = model
        self.object = object
        self.created = created
        self.choices = choices
        self.usage = usage
    }
}
