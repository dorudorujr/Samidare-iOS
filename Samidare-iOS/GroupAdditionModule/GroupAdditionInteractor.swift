//
//  GroupAdditionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/30.
//

import Foundation

class GroupAdditionInteractor {
    private let questionGroupRepository: QuestionGroupRepository
    
    init(questionGroupRepository: QuestionGroupRepository = QuestionGroupRepositoryImpl()) {
        self.questionGroupRepository = questionGroupRepository
    }
    
    func getQuestionGroup() -> [QuestionGroup] {
        questionGroupRepository.get()
    }
    
    func add(_ questionGroup: QuestionGroup) throws {
        try questionGroupRepository.add(questionGroup)
    }

    func delete(_ questionGroup: QuestionGroup) throws {
        try questionGroupRepository.delete(questionGroup)
    }
}
