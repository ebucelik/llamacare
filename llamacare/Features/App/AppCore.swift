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
    }

    enum Action: ViewAction {
        enum ViewAction {
        }

        case view(ViewAction)
        case chatAction(ChatCore.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.chatState, action: \.chatAction) {
            ChatCore()
                .dependency(\.openRouterService, OpenRouterService())
        }

        Reduce { state, action in
            switch action {
            case .view:
                return .none

            case .chatAction:
                return .none
            }
        }
    }
}
