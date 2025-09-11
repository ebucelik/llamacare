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

    let store: StoreOf<AppCore>

    var body: some View {
        NavigationStack {
            TabView {
                Tab("Chat", systemImage: "paperplane.fill") {
                    ChatView(
                        store: store.scope(state: \.chatState, action: \.chatAction)
                    )
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
            .tint(AppColor.secondary)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
