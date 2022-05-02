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
    
    @Published var isShowingAddAlert = false
    @Published var questions: [Question]?
    @Published var addQuestionBody = ""
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
    
    func didTapNavBarButton() {
        isShowingAddAlert = true
    }
}
