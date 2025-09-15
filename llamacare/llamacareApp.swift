//
//  llamacareApp.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.09.25.
//

import ComposableArchitecture
import SwiftUI
import RevenueCat

@main
struct llamacareApp: App {
    @AppStorage("appearance") private var selectedAppearance: Appearance = .system

    init() {
        Purchases.configure(withAPIKey: "appl_oImXgLzHdwcmyOBbTEfgKzxTfKC")
    }

    var body: some Scene {
        WindowGroup {
            withDependencies {
                $0.appStyle = AppStyle()
            } operation: {
                AppView(
                    store: Store(
                        initialState: AppCore.State(),
                        reducer: {
                            AppCore()
                                .dependency(\.openRouterService, OpenRouterService())
                        }
                    )
                )
                .preferredColorScheme(selectedAppearance.getColorScheme())
            }
        }
    }
}
