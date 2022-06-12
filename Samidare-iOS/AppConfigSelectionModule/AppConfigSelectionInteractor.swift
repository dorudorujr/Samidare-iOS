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
    
    func update(_ questionGroup: String) throws {
        let currentAppConfig = AppConfigRepository.get()
        let updateAppConfig = AppConfig(id: currentAppConfig.id, gameType: currentAppConfig.gameType, questionGroup: .init(name: questionGroup), time: currentAppConfig.time)
        try AppConfigRepository.update(updateAppConfig)
    }
}
