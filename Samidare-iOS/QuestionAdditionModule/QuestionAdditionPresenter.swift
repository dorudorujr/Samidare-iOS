//
//  QuestionAdditionPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/01.
//

import Combine

@MainActor
class QuestionAdditionPresenter: ObservableObject {
    private let interactor: QuestionAdditionInteractor
    private let group: String
    
    private var questionToUpdate: Question?
    
    @Published var isShowingAddAlert = false
    @Published var isShowingUpdateAlert = false
    @Published var questions: [Question]?
    @Published var addQuestionBody = ""
    @Published var updateQuestionBody = ""
    @Published var error: Error?
    
    init(interactor: QuestionAdditionInteractor, group: String) {
        self.interactor = interactor
        self.group = group
        questions = interactor.getQuestions(of: group)
    }
    
    func addQuestion() {
        do {
            let question = Question(body: addQuestionBody, group: .init(name: group))
            try interactor.add(question)
            questions = interactor.getQuestions(of: group)
        } catch {
            self.error = error
        }
    }
    
    func updateQuestion() {
        do {
            guard let questionToUpdate = questionToUpdate else {
                return
            }
            let question = Question(id: questionToUpdate.id,
                                    body: updateQuestionBody,
                                    group: questionToUpdate.group)
            try interactor.update(question)
            questions = interactor.getQuestions(of: group)
            // 不整合が起きないように更新が完了したら初期化しておく
            self.questionToUpdate = nil
        } catch {
            self.error = error
        }
    }
    
    func didTapNavBarButton() {
        isShowingAddAlert = true
    }
    
    func didTapList(question: Question) {
        updateQuestionBody = question.body
        isShowingUpdateAlert = true
        questionToUpdate = question
    }
}
