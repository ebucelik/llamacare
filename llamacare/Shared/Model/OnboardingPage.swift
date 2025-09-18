//
//  OnboardingPage.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.09.25.
//

import Foundation
import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let lottieResource: String

    init(title: String, text: String, lottieResource: String) {
        self.title = title
        self.text = text
        self.lottieResource = lottieResource
    }
}

extension OnboardingPage {
    static let pages = [
        OnboardingPage(
            title: "Welcome to LlamaCare",
            text: "Meet your llama buddy — here to lift your mood and brighten your day.",
            lottieResource: "Codepaca"
        ),
        OnboardingPage(
            title: "Always There",
            text: "Chat anytime for positivity, calm, and a little cheer.",
            lottieResource: "Chat"
        ),
        OnboardingPage(
            title: "Start Now",
            text: "Discover small steps toward happier days.",
            lottieResource: "RocketLoader"
        )
    ]
}
