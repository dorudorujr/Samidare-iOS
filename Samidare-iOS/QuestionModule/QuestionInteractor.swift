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
         questionRepository: QuestionRepository = QuestionRepositoryImpl()) throws {
        self.appConfigRepository = appConfigRepository
        self.questionRepository = questionRepository
        group = try appConfigRepository.get().questionGroup.name
    }

    func getQuestion(from index: Int) throws -> Question {
        let questions = try questionRepository.getQuestions(of: group)
        if questions.count <= index {
            assert(true)
            return .init(body: "", group: .init(name: group))
        } else {
            return questions[index]
        }
    }
    
    func getTotalQuestionCount() throws -> Int {
        return try questionRepository.getQuestions(of: group).count
    }

    func getTime() throws -> Int {
        return try appConfigRepository.get().time
    }
}
