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
    
    @Published private(set) var questionGroup: String?
    @Published private(set) var playTime: String?
    
    let appVersion: String
    
    init(interactor: ConfigInteractor<Repository>, router: ConfigRouter) {
        self.interactor = interactor
        self.router = router
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    func getAppConfig() {
        let appConfig = interactor.getAppConfig()
        questionGroup = appConfig.questionGroup.name
        playTime = appConfig.time.description
    }
    
    func groupAdditionLinkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeGroupAdditionView()) {
            content()
        }
    }
    
    func appConfigSelectionLinkBuilder<Content: View>(for type: AppConfigSelectionType, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeAppConfigSelectionView(for: type) { [weak self] in
            self?.getAppConfig()
        }) {
            content()
        }
    }
}
