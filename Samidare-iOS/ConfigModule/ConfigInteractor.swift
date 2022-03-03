//
//  ConfigInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/03.
//

import Foundation

class ConfigInteractor {
    private let appConfigRepository: AppConfigRepository

    init(appConfigRepository: AppConfigRepository = AppConfigRepositoryImpl()) {
        self.appConfigRepository = appConfigRepository
    }
    
    func getQuestionGroup() throws -> QuestionGroup {
        let appConfig = try appConfigRepository.get()
        return appConfig.questionGroup
    }
    
    func getPlayTime() throws -> Int {
        let appConfig = try appConfigRepository.get()
        return appConfig.time
    }
    
    func getGameType() throws -> GameType {
        let appConfig = try appConfigRepository.get()
        return appConfig.gameType
    }
}
