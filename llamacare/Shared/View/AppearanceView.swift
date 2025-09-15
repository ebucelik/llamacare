//
//  AppearanceView.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 15.09.25.
//

import SwiftUI

extension Appearance {
    func getColorScheme() -> ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .light
        }
    }
}

struct AppearanceView: View {
    @AppStorage("appearance") private var selectedAppearance: Appearance = .system

    var body: some View {
        VStack {
            Text("Select Appearance")
                .font(.headline)
                .padding()
            
            Picker("Appearance", selection: $selectedAppearance) {
                ForEach(Appearance.allCases) { mode in
                    Text(mode.rawValue)
                        .tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
        }
        .preferredColorScheme(selectedAppearance.getColorScheme())
    }
}
