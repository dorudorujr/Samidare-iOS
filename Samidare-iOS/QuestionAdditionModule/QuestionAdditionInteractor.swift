//
//  QuestionAdditionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/01.
//

import Foundation

class QuestionAdditionInteractor {
    private let questionRepository: QuestionRepository
    
    init(questionRepository: QuestionRepository = QuestionRepositoryImpl()) {
        self.questionRepository = questionRepository
    }
    
    func getQuestions(of group: String) -> [Question] {
        questionRepository.getQuestions(of: group)
    }
    
    func add(_ question: Question) throws {
        try questionRepository.add(question)
    }
    
    func update(_ question: Question) throws {
        try questionRepository.update(question)
    }
    
    func delete(_ question: Question) throws {
        try questionRepository.delete(question)
    }
}
