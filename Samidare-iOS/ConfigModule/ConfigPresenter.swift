//
//  ConfigPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import Combine
import SwiftUI

@MainActor
class ConfigPresenter<Repository: AppConfigRepositoryProtocol>: ObservableObject {
    private let interactor: ConfigInteractor<Repository>
    private let router: ConfigRouter
    
    @Published var questionGroup: String?
    @Published var playTime: String?
    @Published var gameType: String?
    @Published var appVersion: String?
    
    init(interactor: ConfigInteractor<Repository>, router: ConfigRouter) {
        self.interactor = interactor
        self.router = router
        getAppVersion()
    }
    
    func getAppConfig() {
        let appConfig = interactor.getAppConfig()
        questionGroup = appConfig.questionGroup.name
        playTime = appConfig.time.description
        gameType = appConfig.gameType.name
    }
    
    func groupAdditionLinkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeGroupAdditionView()) {
            content()
        }
    }
    
    private func getAppVersion() {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            appVersion = version
        }
    }
}
