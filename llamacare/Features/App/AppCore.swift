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
        var chatState = ChatCore.State()
        var message: String = ""
    }

    enum Action: ViewAction, BindableAction {
        enum ViewAction {
            case sendMessage
        }

        enum AsyncAction {
            case resetMessage
        }

        case view(ViewAction)
        case async(AsyncAction)
        case chatAction(ChatCore.Action)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.chatState, action: \.chatAction) {
            ChatCore()
                .dependency(\.openRouterService, OpenRouterService())
        }

        Reduce { state, action in
            switch action {
            case let .view(action):
                switch action {
                case .sendMessage:
                    guard !state.message.isEmpty else { return .none }

                    return .concatenate(
                        [
                            .send(.chatAction(.delegate(.sendMessage(state.message)))),
                            .send(.async(.resetMessage))
                        ]
                    )
                }

            case let .async(action):
                switch action {
                case .resetMessage:
                    state.message = ""

                    return .none
                }

            case .chatAction:
                return .none

            case .binding:
                return .none
            }
        }
    }
}
