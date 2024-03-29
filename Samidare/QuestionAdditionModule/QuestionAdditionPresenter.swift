//
//  QuestionAdditionPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/05/01.
//

import Combine
import Foundation

@MainActor
class QuestionAdditionPresenter<Repository: QuestionRepositoryProtocol>: ObservableObject {
    private let interactor: QuestionAdditionInteractor<Repository>
    
    private var questionToUpdate: Question?
    
    let group: QuestionGroup
    
    @Published private(set) var questions: [Question]?
    @Published var isShowingAddAlert = false
    @Published var isShowingUpdateAlert = false
    @Published var addQuestionBody = ""
    @Published var updateQuestionBody = ""
    @Published var isShowingErrorAlert = false
    
    init(interactor: QuestionAdditionInteractor<Repository>, group: QuestionGroup) {
        self.interactor = interactor
        self.group = group
        questions = interactor.getQuestions(of: group.name)
    }
    
    func addQuestion() {
        FirebaseAnalyticsConfig.sendEventLog(eventType: .addQuestion)
        do {
            let question = Question(body: addQuestionBody, group: group)
            try interactor.add(question)
            questions = interactor.getQuestions(of: group.name)
        } catch {
            Log.fault(error, className: String(describing: type(of: self)), functionName: #function)
            isShowingErrorAlert = true
        }
    }
    
    func updateQuestion() {
        FirebaseAnalyticsConfig.sendEventLog(eventType: .updateQuestion)
        do {
            guard let questionToUpdate = questionToUpdate else {
                return
            }
            let question = Question(id: questionToUpdate.id,
                                    body: updateQuestionBody,
                                    group: questionToUpdate.group)
            try interactor.update(question)
            questions = interactor.getQuestions(of: group.name)
            // 不整合が起きないように更新が完了したら初期化しておく
            self.questionToUpdate = nil
        } catch {
            isShowingErrorAlert = true
        }
    }
    
    func deleteQuestion(on index: IndexSet) {
        FirebaseAnalyticsConfig.sendEventLog(eventType: .deleteQuestion)
        guard let index = index.first, let question = questions?[safe: index] else { return }
        do {
            try interactor.delete(question)
            questions = interactor.getQuestions(of: group.name)
        } catch {
            isShowingErrorAlert = true
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
