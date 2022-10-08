//
//  GroupAdditionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/30.
//

import Foundation

class GroupAdditionInteractor<Repository: QuestionGroupRepositoryProtocol> {
    func getQuestionGroup() -> [QuestionGroup] {
        Repository.get()
    }
    
    func add(_ questionGroup: QuestionGroup) throws {
        try Repository.add(questionGroup)
    }

    func delete(_ questionGroup: QuestionGroup) throws {
        try Repository.delete(questionGroup)
    }
}
