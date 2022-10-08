//
//  Config.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import Foundation

struct AppConfig: Codable, Equatable {
    let questionGroup: QuestionGroup
    let time: Int
}
