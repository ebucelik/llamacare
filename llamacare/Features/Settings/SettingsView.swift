//
//  SettingsView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 11.09.25.
//

import Dependencies
import SwiftUI

struct SettingsView: View {

    @State
    var showAppearance = false

    @Dependency(\.appStyle) var appStyle

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Button {
                showAppearance.toggle()
            } label: {
                HStack {
                    Text("Appearance")
                        .font(appStyle.font(.body(.bold)))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                }
                .frame(height: 50)
                .foregroundStyle(appStyle.color(.surfaceInverse))

                Spacer()
            }
            .buttonStyle(.glass)

            Spacer()

            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                Text("Version \(appVersion)")
                    .font(appStyle.font(.caption(.regular)))
                    .padding(8)
                    .glassEffect()
                    .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $showAppearance) {
            AppearanceView()
                .presentationDetents([.medium])
        }
        .background(
            ZStack {
                Color.gray
                    .opacity(0.25)
                    .ignoresSafeArea()

                Color.white
                    .opacity(0.7)
                    .blur(radius: 200)
                    .ignoresSafeArea()

                GeometryReader { proxy in
                    let size = proxy.size

                    Circle()
                        .fill(appStyle.color(.primary))
                        .padding(50)
                        .blur(radius: 180)
                        .glassEffect(in: Circle())
                        .offset(x: -size.width / 1.8, y: -size.height / 5)

                    Circle()
                        .fill(appStyle.color(.secondary))
                        .padding(50)
                        .blur(radius: 200)
                        .glassEffect(in: Circle())
                        .offset(x: size.width / 1.8, y: size.height / 2)
                }
            }
        )
    }
}
