//
//  ChatCore.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 11.09.25.
//

import ComposableArchitecture
import SwiftHelper
import RevenueCat

@Reducer
struct ChatCore {
    @ObservableState
    struct State: Equatable {
        var defaultConfigMessage = "Write in sentences. Act like a human chat bot. Be sensitive, empathetic and caring. Ask questions when needed. It should be a mood boosting conversation. Stay on the language you are receiving. Use emojis. Keep it short."

        var initialMessage: String? = "Your name is LlamaCare. Now say hi to the user."

        var openRouterResponse: Loadable<OpenRouterResponse> = .none

        var messages: [OpenRouterMessage.Message] = []

        var message: String = ""

        var isOpenRouterResponseLoading: Bool {
            if case .loading = openRouterResponse {
                return true
            }

            return false
        }

        var isEntitled = false
    }

    enum Action: ViewAction, BindableAction {
        enum ViewAction {
            case onAppear
            case setIsEntitled(Bool)
            case sendMessage
        }

        enum AsyncAction {
            case sendMessageRequest(String)
            case setOpenRouterResponse(Loadable<OpenRouterResponse>)
            case setIsEntitled(Bool)
            case resetMessage
        }

        case view(ViewAction)
        case async(AsyncAction)
        case binding(BindingAction<State>)
    }

    @Dependency(\.openRouterService) var openRouterService

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .view(action):
                switch action {
                case .onAppear:
                    var effects: [Effect<Action>] = [
                        .run { send in
                            let customerInfo = try await Purchases.shared.customerInfo()

                            if customerInfo.entitlements.all["pro"]?.isActive == true {
                                await send(.async(.setIsEntitled(true)))
                            }
                        } catch: { error, send in
                            print(error.localizedDescription)

                            await send(.async(.setIsEntitled(false)))
                        }
                    ]

                    guard let message = state.initialMessage else { return .concatenate(effects) }

                    effects.append(.send(.async(.sendMessageRequest(message))))

                    return .concatenate(effects)

                case let .setIsEntitled(isEntitled):
                    return .send(.async(.setIsEntitled(isEntitled)))

                case .sendMessage:
                    guard !state.message.isEmpty else { return .none }

                    return .concatenate(
                        [
                            .send(.async(.sendMessageRequest(state.message))),
                            .send(.async(.resetMessage))
                        ]
                    )
                }

            case let .async(action):
                switch action {
                case let .sendMessageRequest(message):
                    guard !message.isEmpty && !state.isOpenRouterResponseLoading
                    else { return .none }

                    if state.initialMessage == nil {
                        state.messages.append(
                            OpenRouterMessage.Message(content: message)
                        )
                    }

                    let content = state.defaultConfigMessage + "\n\n" + message
                    let message = OpenRouterMessage.Message(content: content)

                    let openRouterMessage = OpenRouterMessage(messages: [message])

                    return .run { send in
                        await send(.async(.setOpenRouterResponse(.loading)))

                        let openMessageResponse = try await self.openRouterService.sendMessage(openRouterMessage: openRouterMessage)

                        await send(.async(.setOpenRouterResponse(.loaded(openMessageResponse))))
                    } catch: { error, send in
                        if let apiError = error as? APIError {
                            await send(.async(.setOpenRouterResponse(.error(apiError))))
                        }
                    }

                case let .setOpenRouterResponse(openRouterResponse):
                    state.openRouterResponse = openRouterResponse

                    if case let .loaded(openRouterResponse) = openRouterResponse {
                        openRouterResponse.choices.forEach { choice in
                            state.messages.append(choice.message)
                        }
                    }

                    if state.initialMessage != nil {
                        state.initialMessage = nil
                    }

                    return .none

                case let .setIsEntitled(isEntitled):
                    state.isEntitled = isEntitled

                    return .none

                case .resetMessage:
                    state.message = ""

                    return .none
                }

            case .binding:
                return .none
            }
        }
    }
}
