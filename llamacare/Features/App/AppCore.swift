//
//  AppCore.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 10.09.25.
//

import ComposableArchitecture

@Reducer
struct AppCore {
    @ObservableState
    struct State: Equatable {
        var openRouterMessage: OpenRouterMessage?
        var openRouterResponse: OpenRouterResponse?
    }

    enum Action: ViewAction {
        enum ViewAction {
            case onAppear
        }

        enum AsyncAction {
            case sendMessage
        }

        case view(ViewAction)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(action):
                switch action {
                case .onAppear:
                    return .none
                }
            }
        }
    }
}
