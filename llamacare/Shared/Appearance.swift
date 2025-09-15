//
//  Appearance.swift
//  llamacare
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 15.09.25.
//

enum Appearance: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
}
