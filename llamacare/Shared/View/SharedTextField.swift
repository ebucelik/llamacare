//
//  SharedTextField.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 12.09.25.
//

import Dependencies
import SwiftUI
import Combine

struct SharedTextField: View {

    @Dependency(\.appStyle) var appStyle

    let imageSystemName: String?
    @Binding
    var text: String
    let prompt: Text
    let isSecure: Bool
    let maxCharacterCount: Int

    @FocusState var isFocused: Bool

    init(
        imageSystemName: String? = nil,
        text: Binding<String>,
        prompt: Text,
        isSecure: Bool = false,
        maxCharacterCount: Int
    ) {
        self.imageSystemName = imageSystemName
        self._text = text
        self.prompt = prompt
        self.isSecure = isSecure
        self.maxCharacterCount = maxCharacterCount
    }

    var body: some View {
        HStack(spacing: 16) {
            if let imageSystemName {
                Image(systemName: imageSystemName)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(appStyle.color(text.isEmpty ? .disabled : .primary))
            }

            if isSecure {
                SecureField(
                    "",
                    text: $text,
                    prompt: prompt.font(appStyle.font(.subtitle1(.regular)))
                )
                .focused($isFocused)
                .frame(maxWidth: .infinity)
                .font(appStyle.font(.subtitle1(.regular)))
            } else {
                TextField(
                    "",
                    text: $text,
                    prompt: prompt.font(appStyle.font(.subtitle1(.regular)))
                )
                .focused($isFocused)
                .frame(maxWidth: .infinity)
                .font(appStyle.font(.subtitle1(.regular)))
                .onReceive(Just(text)) { _ in
                    if text.count > maxCharacterCount {
                        text = String(text.prefix(maxCharacterCount))
                    }
                }
            }
        }
        .padding()
    }
}
