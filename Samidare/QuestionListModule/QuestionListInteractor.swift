//
//  QuestionListInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/05.
//

import Foundation

class QuestionListInteractor<Repository: QuestionRepositoryProtocol> {
    func getQuestions(of group: String) -> [Question] {
        Repository.getQuestions(of: group)
    }
}
