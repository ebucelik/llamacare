//
//  OnboardingView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.09.25.
//

import Dependencies
import SwiftUI
import Lottie

struct OnboardingView: View {

    @Environment(\.dismiss) var dismiss

    @Dependency(\.appStyle) var appStyle

    var body: some View {
        VStack {
            TabView {
                ForEach(OnboardingPage.pages, id: \.id) { page in
                    VStack {
                        Text(page.title)
                            .font(appStyle.font(.title(.bold)))
                            .padding(.bottom, 25)
                            .multilineTextAlignment(.center)

                        Text(page.text)
                            .font(appStyle.font(.subtitle(.regular)))
                            .multilineTextAlignment(.center)

                        Spacer()

                        LottieView(animation: .named(page.lottieResource))
                            .resizable()
                            .looping()
                            .scaledToFit()

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack {
                    Spacer()

                    Text("OK")
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)

                    Spacer()
                }
                .frame(height: 50)
            }
            .buttonStyle(.glassProminent)
            .padding(16)
        }
        .interactiveDismissDisabled()
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .label
            UIPageControl.appearance().pageIndicatorTintColor = .systemGray
        }
    }
}
