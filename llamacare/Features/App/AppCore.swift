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
        var message: String = ""

        var showInfo = false

        var tabSelection = 0

        var isEntitled = false
    }

    enum Action: ViewAction, BindableAction {
        enum ViewAction {
            case onAppear
            case setIsEntitled(Bool)
            case sendMessage
            case infoTapped
        }

        enum AsyncAction {
            case setIsEntitled(Bool)
            case resetMessage
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
                case .onAppear:
                    return .run { send in
                        let customerInfo = try await Purchases.shared.customerInfo()

                        if customerInfo.entitlements.all["pro"]?.isActive == true {
                            await send(.async(.setIsEntitled(true)))
                        }
                    } catch: { error, send in
                        print(error.localizedDescription)

                        await send(.async(.setIsEntitled(false)))
                    }

                case let .setIsEntitled(isEntitled):
                    return .send(.async(.setIsEntitled(isEntitled)))

                case .sendMessage:
                    guard !state.message.isEmpty else { return .none }

                    return .concatenate(
                        [
                            .send(.chatAction(.delegate(.sendMessage(state.message)))),
                            .send(.async(.resetMessage))
                        ]
                    )

                case .infoTapped:
                    return .send(.async(.showInfoView))
                }

            case let .async(action):
                switch action {
                case let .setIsEntitled(isEntitled):
                    state.isEntitled = isEntitled

                    return .none

                case .resetMessage:
                    state.message = ""

                    return .none

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
