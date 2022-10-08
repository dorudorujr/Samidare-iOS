//
//  QuestionAdditionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/01.
//

import Foundation

class QuestionAdditionInteractor<Repository: QuestionRepositoryProtocol> {
    func getQuestions(of group: String) -> [Question] {
        Repository.getQuestions(of: group)
    }
    
    func add(_ question: Question) throws {
        try Repository.add(question)
    }
    
    func update(_ question: Question) throws {
        try Repository.update(question)
    }
    
    func delete(_ question: Question) throws {
        try Repository.delete(question)
    }
}
