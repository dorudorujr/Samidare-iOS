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
    
    func getAppConfig() -> AppConfig {
        appConfigRepository.get()
    }
}
