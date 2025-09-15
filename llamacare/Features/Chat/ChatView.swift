//
//  ChatView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 11.09.25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: ChatCore.self)
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
            circleView()

            List(store.messages, id: \.self) { message in
                VStack {
                    Text(message.role == "user" ? "You" : "LlamaCare")
                        .font(appStyle.font(.caption(.bold)))
                        .frame(
                            maxWidth: .infinity,
                            alignment: message.role == "user"
                                ? .trailing : .leading
                        )

                    HStack {
                        if message.role == "user" {
                            Spacer()
                        }

                        VStack {
                            Text(message.content)
                        }
                        .padding(16)
                        .glassEffect(
                            message.role == "user"
                                ? .clear
                                : .regular
                                    .tint(appStyle.color(.primary).opacity(0.2))
                        )

                        if message.role == "assistant" {
                            Spacer()
                        }
                    }
                }
                .ignoresSafeArea()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .contentShape(Rectangle())
                .padding(.top, 8)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, 16)

            Spacer()
        }
        .onAppear {
            send(.onAppear)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(
            ZStack {
                Color.gray
                    .opacity(0.25)
                    .ignoresSafeArea()

                Color.white
                    .opacity(0.7)
                    .blur(radius: 200)
                    .ignoresSafeArea()

                GeometryReader { proxy in
                    let size = proxy.size

                    Circle()
                        .fill(appStyle.color(.primary))
                        .padding(50)
                        .blur(radius: 180)
                        .glassEffect(in: Circle())
                        .offset(x: -size.width / 1.8, y: -size.height / 5)

                    Circle()
                        .fill(appStyle.color(.secondary))
                        .padding(50)
                        .blur(radius: 200)
                        .glassEffect(in: Circle())
                        .offset(x: size.width / 1.8, y: size.height / 2)
                }
            }
        )
    }

    @ViewBuilder
    func circleView() -> some View {
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
    }
}
