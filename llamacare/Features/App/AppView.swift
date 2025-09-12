//
//  AppView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 10.09.25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: AppCore.self)
struct AppView: View {

    @Bindable
    var store: StoreOf<AppCore>

    @Dependency(\.appStyle) var appStyle

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

                Tab("Info", systemImage: "info.circle.fill") {
                    InfoView()
                }
            }
            .padding(16)
            .toolbar {
                ToolbarItem(placement: .title) {
                    HStack {
                        Text("LlamaCare")
                            .fontWeight(.bold)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("open revenue cat")
                    } label: {
                        Text("PRO")
                            .fontWeight(.bold)
                    }
                }
            }
            .tabViewBottomAccessory {
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
                        send(.sendMessage)
                    } label: {
                        Image(systemName: "arrowshape.up.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 30, height: 30)
                            .padding(8)
                            .foregroundStyle(store.message.isEmpty ? appStyle.color(.disabled) : appStyle.color(.secondary))
                    }
                    .disabled(store.message.isEmpty)
                }
            }
            .tint(appStyle.color(.secondary))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
