//
//  ColorScheme.swift
//  Kangwon Game Color
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct AppColors {
    static let background = Color(hex: "000000")
    static let primary = Color(hex: "fbd600")
    static let secondary = Color(hex: "ffffff")
    
    // Game specific colors for color matching
    static let gameColors: [Color] = [
        Color(hex: "fbd600"), // Yellow
        Color(hex: "ffffff"), // White
        Color(hex: "ff6b6b"), // Red
        Color(hex: "4ecdc4"), // Teal
        Color(hex: "45b7d1"), // Blue
        Color(hex: "96ceb4"), // Green
        Color(hex: "ffeaa7"), // Light Yellow
        Color(hex: "dda0dd")  // Plum
    ]
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 