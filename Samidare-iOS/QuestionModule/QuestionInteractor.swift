//
//  QuestionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/12/28.
//

import Foundation

class QuestionInteractor<QuestionRepository: QuestionRepositoryProtocol, AppConfigRepository: AppConfigRepositoryProtocol> {
    private let group: String
    
    init() {
        group = AppConfigRepository.get().questionGroup.name
    }

    func getQuestion(from index: Int) -> Question? {
        let questions = QuestionRepository.getQuestions(of: group)
        if questions.count <= index {
            assert(true)
            return nil
        } else {
            return questions[index]
        }
    }
    
    func getTotalQuestionCount() -> Int {
        return QuestionRepository.getQuestions(of: group).count
    }

    func getTime() -> Int {
        return AppConfigRepository.get().time
    }
}
