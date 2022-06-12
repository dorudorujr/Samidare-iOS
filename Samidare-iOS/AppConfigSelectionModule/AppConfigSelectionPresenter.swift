//
//  AppConfigSelectionPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/06/12.
//

import Combine
import SwiftUI

@MainActor
class AppConfigSelectionPresenter<AppConfigRepository: AppConfigRepositoryProtocol, GroupRepository: QuestionGroupRepositoryProtocol>: ObservableObject {
    private let interactor: AppConfigSelectionInteractor<AppConfigRepository, GroupRepository>
    
    @Published var questionGroups: [QuestionGroup]
    @Published var error: Error?
    
    init(interactor: AppConfigSelectionInteractor<AppConfigRepository, GroupRepository>) {
        self.interactor = interactor
        questionGroups = interactor.questionGroups()
    }
    
    func fetchQuestionGroups() {
        questionGroups = interactor.questionGroups()
    }
    
    func update(_ questionGroup: String) {
        do {
            try interactor.update(questionGroup)
            fetchQuestionGroups()
        } catch {
            self.error = error
        }
    }
    
    func isSelectedQuestionGroup(questionGroup: QuestionGroup) -> Bool {
        interactor.selectQuestionGroup().name == questionGroup.name
    }
}
