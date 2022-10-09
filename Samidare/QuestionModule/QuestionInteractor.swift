//
//  QuestionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/12/28.
//

import Foundation

class QuestionInteractor<QuestionRepository: QuestionRepositoryProtocol, AppConfigRepository: AppConfigRepositoryProtocol> {

    func getQuestion(from index: Int) -> Question? {
        let group = AppConfigRepository.get().questionGroupName
        let questions = QuestionRepository.getQuestions(of: group)
        return questions[safe: index]
    }
    
    func getTotalQuestionCount() -> Int {
        let group = AppConfigRepository.get().questionGroupName
        return QuestionRepository.getQuestions(of: group).count
    }

    func getTime() -> Int {
        return AppConfigRepository.get().time
    }
    
    func questionGroup() -> String {
        AppConfigRepository.get().questionGroupName
    }
}
