//
//  llamacareApp.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.09.25.
//

import ComposableArchitecture
import SwiftUI

@main
struct llamacareApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppCore.State(),
                    reducer: {
                        AppCore()
                            .dependency(\.openRouterService, OpenRouterService())
                    }
                )
            )
        }
    }
}
