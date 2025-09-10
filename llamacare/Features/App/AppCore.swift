//
//  AppCore.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 10.09.25.
//

import ComposableArchitecture
import SwiftHelper

@Reducer
struct AppCore {
    @ObservableState
    struct State: Equatable {
        var message: String = ""
        var openRouterResponse: Loadable<OpenRouterResponse> = .none

        var isOpenRouterResponseLoading: Bool {
            if case .loading = openRouterResponse {
                return true
            }

            return false
        }
    }

    enum Action: ViewAction, BindableAction {
        enum ViewAction {
            case onAppear
            case sendMessage
        }

        enum AsyncAction {
            case sendMessageRequest
            case setOpenRouterResponse(Loadable<OpenRouterResponse>)
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
                    return .none

                case .sendMessage:
                    return .send(.async(.sendMessageRequest))
                }

            case let .async(action):
                switch action {
                case .sendMessageRequest:
                    guard !state.message.isEmpty else { return .none }

                    let message = "Write in sentences. Be sensitive, empathetic and caring. Ask questions if needed. It should be a mood boosting conversation. Keep it short.\n\n" + state.message

                    let openRouterMessage = OpenRouterMessage(
                        messages: [
                            OpenRouterMessage.Message(content: message)
                        ]
                    )

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

                    return .none
                }

            case .binding:
                return .none
            }
        }
    }
}
