//
//  ConfigInteractor.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/03.
//

import Foundation

class ConfigInteractor<Repository: AppConfigRepositoryProtocol> {
    init() {}
    
    func getAppConfig() -> AppConfig {
        Repository.get()
    }
}
