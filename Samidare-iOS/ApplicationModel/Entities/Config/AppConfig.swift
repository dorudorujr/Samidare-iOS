//
//  Config.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import Foundation

struct AppConfig {
    let id: UUID
    let questionGroup: QuestionGroup
    let time: Int
}

extension AppConfig {
    init(questionGroup: QuestionGroup, time: Int) {
        self.id = UUID()
        self.questionGroup = questionGroup
        self.time = time
    }
}
