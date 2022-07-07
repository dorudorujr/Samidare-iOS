//
//  AppConfigSelectionInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/06/12.
//

import Foundation

class AppConfigSelectionInteractor<AppConfigRepository: AppConfigRepositoryProtocol, GroupRepository: QuestionGroupRepositoryProtocol> {
    func questionGroups() -> [QuestionGroup] {
        GroupRepository.get()
    }
    
    func gameTime() -> Int {
        AppConfigRepository.get().time
    }
    
    func selectQuestionGroup() -> QuestionGroup {
        AppConfigRepository.get().questionGroup
    }
    
    func update(questionGroup: String) throws {
        let currentAppConfig = AppConfigRepository.get()
        let updateAppConfig = AppConfig(id: currentAppConfig.id, gameType: currentAppConfig.gameType, questionGroup: .init(name: questionGroup), time: currentAppConfig.time)
        try AppConfigRepository.update(updateAppConfig)
    }
    
    func update(gameTime: Int) throws {
        let currentAppConfig = AppConfigRepository.get()
        let updateAppConfig = AppConfig(id: currentAppConfig.id, gameType: currentAppConfig.gameType, questionGroup: currentAppConfig.questionGroup, time: gameTime)
        try AppConfigRepository.update(updateAppConfig)
    }
}