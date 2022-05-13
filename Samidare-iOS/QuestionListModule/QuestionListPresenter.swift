//
//  QuestionListPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/05.
//

import Foundation

class QuestionListPresenter {
    let questions: [Question]?
    
    init(interactor: QuestionAdditionInteractor, group: String?) {
        if let group = group {
            questions = interactor.getQuestions(of: group)
        } else {
            questions = nil
        }
    }
}
