//
//  Color+RGB.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/01/10.
//

import Foundation
import SwiftUI

extension Color {
    static func rgba(_ red: Int, _ green: Int, _ blue: Int, _ opacity: Double = 1.0) -> Color {
        Color(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, opacity: opacity)
    }
    
    static var textBlack: Color {
        Color.rgba(90, 93, 93)
    }
    
    static var bassBlue: Color {
        Color.rgba(1, 115, 213)
    }
    
    static var whitesmoke: Color {
        Color.rgba(245, 245, 245)
    }
    
    static var questionRed: Color {
        Color.rgba(245, 96, 96)
    }
    
    static var questionGray: Color {
        Color.rgba(146, 147, 147)
    }

    static var orangered: Color {
        Color.rgba(255, 69, 0)
    }
}
