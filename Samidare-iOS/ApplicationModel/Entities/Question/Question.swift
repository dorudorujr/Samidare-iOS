//
//  Question.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/11/14.
//

import Foundation

struct Question {
    let id = UUID()
    let body: String
    let group: QuestionGroup
}
