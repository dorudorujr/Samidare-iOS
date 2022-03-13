//
//  QuestionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2021/12/28.
//

import Foundation

class QuestionInteractor {
    private let appConfigRepository: AppConfigRepository
    private let questionRepository: QuestionRepository
    private let group: String
    
    init(appConfigRepository: AppConfigRepository = AppConfigRepositoryImpl(),
         questionRepository: QuestionRepository = QuestionRepositoryImpl()) {
        self.appConfigRepository = appConfigRepository
        self.questionRepository = questionRepository
        group = appConfigRepository.get().questionGroup.name
    }

    func getQuestion(from index: Int) -> Question? {
        let questions = questionRepository.getQuestions(of: group)
        if questions.count <= index {
            assert(true)
            return nil
        } else {
            return questions[index]
        }
    }
    
    func getTotalQuestionCount() -> Int {
        return questionRepository.getQuestions(of: group).count
    }

    func getTime() -> Int {
        return appConfigRepository.get().time
    }
}
