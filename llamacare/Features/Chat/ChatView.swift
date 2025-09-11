//
//  ChatView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 11.09.25.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {

    @Bindable
    var store: StoreOf<ChatCore>

    var body: some View {
        Text("Chat")
    }
}
