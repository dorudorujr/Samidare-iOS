//
//  UIColor+RGB.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/07.
//

import Foundation
import UIKit

extension UIColor {
    class func rgba(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1) -> UIColor {
        UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    static var tabGray: UIColor {
        .rgba(249, 249, 249, 0.94)
    }
}
