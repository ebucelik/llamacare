//
//  AppCore.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 10.09.25.
//

import ComposableArchitecture
import SwiftHelper
import RevenueCat

@Reducer
struct AppCore {
    @ObservableState
    struct State: Equatable {
        var chatState = ChatCore.State()
        var showInfo = false
    }

    enum Action: ViewAction, BindableAction {
        enum ViewAction {
            case infoTapped
            case setIsEntitled(Bool)
        }

        enum AsyncAction {
            case showInfoView
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
                case .infoTapped:
                    return .send(.async(.showInfoView))

                case let .setIsEntitled(isEntitled):
                    return .send(.chatAction(.view(.setIsEntitled(isEntitled))))
                }

            case let .async(action):
                switch action {
                case .showInfoView:
                    state.showInfo = true

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
