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
    private let type: AppConfigSelectionType
    
    @Published private(set) var questionGroups: [QuestionGroup]?
    @Published private(set) var appConfigGameTime: Int?
    @Published var error: Error?
    
    init(interactor: AppConfigSelectionInteractor<AppConfigRepository, GroupRepository>,
         type: AppConfigSelectionType) {
        self.interactor = interactor
        self.type = type
        if type == .questionGroup {
            questionGroups = interactor.questionGroups()
        } else {
            appConfigGameTime = interactor.gameTime()
        }
    }
    
    func fetchQuestionGroups() {
        guard type == .questionGroup else { return }
        questionGroups = interactor.questionGroups()
    }
    
    func update(questionGroup: String) {
        guard type == .questionGroup else { return }
        do {
            try interactor.update(questionGroup: questionGroup)
            fetchQuestionGroups()
        } catch {
            self.error = error
        }
    }
    
    func update(gameTime: Int) {
        guard type == .gameTime else { return }
        do {
            try interactor.update(gameTime: gameTime)
            appConfigGameTime = interactor.gameTime()
        } catch {
            self.error = error
        }
    }
    
    func isSelectedQuestionGroup(questionGroup: QuestionGroup) -> Bool {
        interactor.selectQuestionGroup().name == questionGroup.name
    }
}
