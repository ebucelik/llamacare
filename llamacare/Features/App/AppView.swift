//
//  AppView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 10.09.25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: AppCore.self)
struct AppView: View {

    @Bindable
    var store: StoreOf<AppCore>

    var body: some View {
        VStack {
            if store.isOpenRouterResponseLoading {
                ProgressView().progressViewStyle(.circular)
            } else if case let .loaded(openRouterResponse) = store.openRouterResponse {
                ForEach(openRouterResponse.choices, id: \.self) { choice in
                    Text(choice.message.content)
                }
            }

            Spacer()

            HStack {
                TextField("", text: $store.message, prompt: Text("Write a message..."))

                Button {
                    send(.sendMessage)
                } label: {
                    Text("Send")
                }
            }
        }
        .padding(16)
    }
}
