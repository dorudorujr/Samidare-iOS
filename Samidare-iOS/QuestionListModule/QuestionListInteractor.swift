//
//  QuestionListInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/05.
//

import Foundation

class QuestionListInteractor {
    private let questionRepository: QuestionRepository
    
    init(questionRepository: QuestionRepository = QuestionRepositoryImpl()) {
        self.questionRepository = questionRepository
    }
    
    func getQuestions(of group: String) -> [Question] {
        questionRepository.getQuestions(of: group)
    }
}
