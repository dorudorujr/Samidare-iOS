//
//  GameTime.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/06/12.
//

import Foundation

enum GameTime: Int, CaseIterable, Identifiable {
    case five = 5
    case ten = 10
    case twenty = 20
    case thirty = 30
    case forty = 40
    case fifty = 50
    case sixty = 60
    
    var id: String { rawValue.description }
}
