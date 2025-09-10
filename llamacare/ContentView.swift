//
//  ContentView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.09.25.
//

import MLX
import MLXLLM
import MLXLMCommon
import SwiftUI

struct ContentView: View {

    let apiClient = APIClient()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                do {
                    let openRouterResponse = try await apiClient.start(
                        call: OpenRouterCall(
                            openRouterMessage: OpenRouterMessage(
                                messages: [
                                    OpenRouterMessage.Message(
                                        content:
                                            "Act like a chat bot & write in sentences instead of listing. Can you tell me some motivational words to cheer me up? Keep it short."
                                    )
                                ]
                            )
                        )
                    )

                    openRouterResponse.choices.forEach { choice in
                        print(choice.message.content)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
