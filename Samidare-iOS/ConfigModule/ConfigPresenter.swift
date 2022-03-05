//
//  ConfigPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import Combine
import SwiftUI

class ConfigPresenter: ObservableObject {
    private let interactor: ConfigInteractor
    
    @Published var questionGroup: String?
    @Published var playTime: String?
    @Published var gameType: String?
    @Published var appVersion: String?
    @Published var error: Error?
    
    init(interactor: ConfigInteractor) {
        self.interactor = interactor
        getAppVersion()
    }
    
    func getAppConfig() {
        do {
            let appConfig = try interactor.getAppConfig()
            questionGroup = appConfig.questionGroup.name
            playTime = appConfig.time.description
            gameType = appConfig.gameType.name
        } catch {
            self.error = error
        }
    }
    
    private func getAppVersion() {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            appVersion = version
        }
    }
}
