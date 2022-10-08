//
//  QuestionGroupUniqueError.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/08/17.
//

import Foundation

struct QuestionGroupUniqueError: Error {
    let code: Int = -3999
    var localizedDescription: String = "QuestionGroup is unique"
}
