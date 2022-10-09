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
    @Published var isShowingErrorAlert = false
    
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
    
    func update(questionGroup: QuestionGroup) {
        FirebaseAnalyticsConfig.sendEventLog(eventType: .changeQuestionGroup)
        guard type == .questionGroup else { return }
        do {
            try interactor.update(questionGroup: questionGroup)
            fetchQuestionGroups()
        } catch {
            Log.fault(error, className: String(describing: Swift.type(of: self)), functionName: #function)
            isShowingErrorAlert = true
        }
    }
    
    func update(gameTime: Int) {
        FirebaseAnalyticsConfig.sendEventLog(eventType: .changeQuestionTime)
        guard type == .gameTime else { return }
        do {
            try interactor.update(gameTime: gameTime)
            appConfigGameTime = interactor.gameTime()
        } catch {
            Log.fault(error, className: String(describing: Swift.type(of: self)), functionName: #function)
            isShowingErrorAlert = true
        }
    }
    
    func isSelectedQuestionGroup(questionGroup: QuestionGroup) -> Bool {
        interactor.selectQuestionGroup() == questionGroup.name
    }
}
