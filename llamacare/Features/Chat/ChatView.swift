//
//  ChatView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 11.09.25.
//

import ComposableArchitecture
import SwiftUI
import RevenueCatUI

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

    @AppStorage("messageSentCounter")
    private var messageSentCounter: Int = 0

    @State
    var showRevenueCatUI = false

    var body: some View {
        VStack {
            circleView()

            ScrollViewReader { scrollViewProxy in
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
                                    .padding(1)
                            }
                            .padding(16)
                            .glassEffect(
                                message.role == "user"
                                    ? .clear
                                    : .regular
                                        .tint(appStyle.color(.primary).opacity(0.2)),
                                in: .rect(cornerRadius: 12)
                            )

                            if message.role == "assistant" {
                                Spacer()
                            }
                        }
                    }
                    .id(message)
                    .ignoresSafeArea()
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .contentShape(Rectangle())
                    .padding(.top, 8)
                    .onChange(of: store.messages) { _, _ in
                        withAnimation {
                            scrollViewProxy.scrollTo(store.messages.last, anchor: .bottom)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 16)
                .ignoresSafeArea(edges: .bottom)
            }

            Spacer()

            HStack {
                withDependencies {
                    $0.appStyle = appStyle
                } operation: {
                    SharedTextField(
                        text: $store.message,
                        prompt: Text("Write a message..."),
                        maxCharacterCount: 200
                    )
                }

                Button {
                    if store.isEntitled || messageSentCounter < 4 {
                        send(.sendMessage)

                        if !store.isEntitled {
                            messageSentCounter += 1
                        }
                    } else {
                        showRevenueCatUI.toggle()
                    }
                } label: {
                    Image(systemName: "arrowshape.up.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .padding(8)
                        .foregroundStyle(store.message.isEmpty ? appStyle.color(.disabled) : appStyle.color(.surfaceInverse))
                }
                .disabled(store.message.isEmpty)
            }
            .glassEffect()
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .onAppear {
            send(.onAppear)
        }
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

                    ZStack {
                        Circle()
                            .fill(appStyle.color(.primary))
                            .padding(50)
                            .blur(radius: 180)
                            .glassEffect(in: Circle())

                        Image("LlamaCareShape")
                            .resizable()
                            .scaledToFit()
                            .padding(100)
                            .rotationEffect(.degrees(45))
                            .offset(x: 50)
                            .opacity(0.1)
                    }
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
        .sheet(isPresented: $showRevenueCatUI) {
            PaywallView(displayCloseButton: true)
                .onPurchaseCompleted { customerInfo in
                    print(customerInfo)

                    send(.setIsEntitled(true))
                }
                .onRestoreCompleted { customerInfo in
                    print(customerInfo)

                    send(.setIsEntitled(true))
                }
                .onPurchaseCancelled {
                    send(.setIsEntitled(false))
                }
        }
    }

    @ViewBuilder
    func circleView() -> some View {
        ZStack {
            if store.isOpenRouterResponseLoading {
                Circle()
                    .frame(width: 140, height: 140)
                    .scaleEffect(thirdCircleAnimationAmount)
                    .animation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: thirdCircleAnimationAmount
                    )
                    .glassEffect(.regular.tint(appStyle.color(.primary).opacity(0.3)), in: Circle())
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

                Circle()
                    .frame(width: 120, height: 120)
                    .scaleEffect(secondCircleAnimationAmount)
                    .animation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: secondCircleAnimationAmount
                    )
                    .glassEffect(.regular.tint(appStyle.color(.primary).opacity(0.6)), in: Circle())

                Circle()
                    .frame(width: 100, height: 100)
                    .scaleEffect(firstCircleAnimationAmount)
                    .animation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: firstCircleAnimationAmount
                    )
                    .glassEffect(.regular.tint(appStyle.color(.primary).opacity(0.8)), in: Circle())
            } else {
                Circle()
                    .glassEffect(.regular.tint(appStyle.color(.primary).opacity(0.3)), in: Circle())
                    .frame(width: 140, height: 140)

                Circle()
                    .glassEffect(.regular.tint(appStyle.color(.primary).opacity(0.6)), in: Circle())
                    .frame(width: 120, height: 120)

                Circle()
                    .glassEffect(.regular.tint(appStyle.color(.primary).opacity(0.8)), in: Circle())
                    .frame(width: 100, height: 100)
            }
        }
    }
}
