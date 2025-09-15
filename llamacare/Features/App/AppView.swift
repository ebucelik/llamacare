//
//  AppView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 10.09.25.
//

import ComposableArchitecture
import SwiftUI
import RevenueCatUI

@ViewAction(for: AppCore.self)
struct AppView: View {

    @Bindable
    var store: StoreOf<AppCore>

    @Dependency(\.appStyle) var appStyle
    @Environment(\.openURL) var openURL

    @AppStorage("messageSentCounter")
    private var messageSentCounter: Int = 0

    @State
    var showRevenueCatUI = false

    var body: some View {
        NavigationStack {
            TabView(selection: $store.tabSelection) {
                Tab("Chat", systemImage: "paperplane.fill", value: 0) {
                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        ChatView(
                            store: store.scope(state: \.chatState, action: \.chatAction)
                        )
                    }
                }

                Tab("Settings", systemImage: "gear", value: 1) {
                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        SettingsView()
                    }
                }
            }
            .onAppear {
                send(.onAppear)
            }
            .toolbar {
                ToolbarItem(placement: .title) {
                    HStack {
                        Text("LlamaCare")
                            .fontWeight(.bold)
                    }
                }

                ToolbarItem {
                    Button {
                        showRevenueCatUI.toggle()
                    } label: {
                        Text("PRO")
                            .fontWeight(.bold)
                    }
                }

                ToolbarItem {
                    Button {
                        send(.infoTapped)
                    } label: {
                        Image(systemName: "info.circle")
                            .renderingMode(.template)
                            .foregroundStyle(appStyle.color(.surfaceInverse))
                    }
                }
            }
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewBottomAccessory {
                if store.tabSelection == 0 {
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
                } else {
                    EmptyView()
                }
            }
            .tint(appStyle.color(.secondary))
            .navigationBarTitleDisplayMode(.inline)
            .onOpenURL(prefersInApp: true)
            .sheet(isPresented: $store.showInfo) {
                VStack(spacing: 16) {
                    Text("Info")
                        .font(appStyle.font(.title2(.bold)))
                        .padding(.vertical, 16)

                    Button {
                        openURL(URL(string: "https://nextgen-apps.com/en/llamacare-terms-of-use.html")!)
                    } label: {
                        HStack {
                            Text("Terms of Use (EULA)")
                                .font(appStyle.font(.body(.bold)))

                            Spacer()

                            Image(systemName: "chevron.right")
                                .renderingMode(.template)
                        }
                        .frame(height: 50)
                    }
                    .buttonStyle(.glass)

                    Button {
                        openURL(URL(string: "https://nextgen-apps.com/en/llamacare-privacy-policy.html")!, prefersInApp: true)
                    } label: {
                        HStack {
                            Text("Privacy Policy")
                                .font(appStyle.font(.body(.bold)))

                            Spacer()

                            Image(systemName: "chevron.right")
                                .renderingMode(.template)
                        }
                        .frame(height: 50)
                    }
                    .buttonStyle(.glass)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .presentationDetents([.medium])
            }
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
    }
}
