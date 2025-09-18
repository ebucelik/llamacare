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

    @State
    var showRevenueCatUI = false

    @AppStorage("isOnboardingShown")
    var isOnboardingShown: Bool = false

    @State
    var showOnboarding = false

    var body: some View {
        NavigationStack {
            TabView {
                Tab("Chat", systemImage: "paperplane.fill") {
                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        ChatView(
                            store: store.scope(state: \.chatState, action: \.chatAction)
                        )
                    }
                }

                Tab("Settings", systemImage: "gear") {
                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        SettingsView()
                    }
                }
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
            .onAppear {
                if !isOnboardingShown {
                    showOnboarding = true
                    isOnboardingShown = true
                }
            }
            .sheet(isPresented: $showOnboarding) {
                withDependencies {
                    $0.appStyle = appStyle
                } operation: {
                    OnboardingView()
                        .onDisappear {
                            showRevenueCatUI = true
                        }
                }
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
            .tabBarMinimizeBehavior(.onScrollDown)
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
        }
    }
}
