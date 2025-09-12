//
//  ChatView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 11.09.25.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {

    @Dependency(\.appStyle) var appStyle

    @Bindable
    var store: StoreOf<ChatCore>

    @State
    var firstCircleAnimationAmount = 1.0

    @State
    var secondCircleAnimationAmount = 1.0

    @State
    var thirdCircleAnimationAmount = 1.0

    var body: some View {
        VStack {
            ZStack {
                if store.isOpenRouterResponseLoading {
                    Circle()
                        .fill(appStyle.color(.primary))
                        .frame(width: 100, height: 100)
                        .scaleEffect(firstCircleAnimationAmount)
                        .animation(
                            .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                            value: firstCircleAnimationAmount
                        )

                    Circle()
                        .fill(appStyle.color(.primary).opacity(0.8))
                        .frame(width: 120, height: 120)
                        .scaleEffect(secondCircleAnimationAmount)
                        .animation(
                            .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                            value: secondCircleAnimationAmount
                        )

                    Circle()
                        .fill(appStyle.color(.primary).opacity(0.6))
                        .frame(width: 140, height: 140)
                        .scaleEffect(thirdCircleAnimationAmount)
                        .animation(
                            .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                            value: thirdCircleAnimationAmount
                        )
                        .onAppear {
                            firstCircleAnimationAmount = 0.9
                            secondCircleAnimationAmount = 0.8
                            thirdCircleAnimationAmount = 0.7
                        }
                        .onDisappear {
                            firstCircleAnimationAmount = 1.0
                            secondCircleAnimationAmount = 1.0
                            thirdCircleAnimationAmount = 1.0
                        }
                } else {
                    Circle()
                        .fill(appStyle.color(.primary))
                        .frame(width: 100, height: 100)

                    Circle()
                        .fill(appStyle.color(.primary).opacity(0.8))
                        .frame(width: 120, height: 120)

                    Circle()
                        .fill(appStyle.color(.primary).opacity(0.6))
                        .frame(width: 140, height: 140)
                }
            }

            if case let .loaded(openRouterResponse) = store.openRouterResponse {
                ForEach(openRouterResponse.choices, id: \.self) { choice in
                    Text(choice.message.content)
                }
            }

            Spacer()
        }
    }
}
