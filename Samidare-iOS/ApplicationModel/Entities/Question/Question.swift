//
//  Question.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import Foundation

struct Question: Identifiable {
    let id: UUID
    let body: String
    let group: QuestionGroup
}

extension Question {
    init(body: String, group: QuestionGroup) {
        self.id = UUID()
        self.body = body
        self.group = group
    }
}
