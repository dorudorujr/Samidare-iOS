//
//  ConfigPresenter.swift
//  Samidare-iOS
//
//  Created by 杉岡成哉 on 2022/03/05.
//

import Combine
import SwiftUI
import MessageUI

@MainActor
class ConfigPresenter<AppConfigRepository: AppConfigRepositoryProtocol, QuestionGroupRepository: QuestionGroupRepositoryProtocol>: ObservableObject {
    enum ExternalLinkType: CaseIterable {
        case privacyPolicy
        case termsOfservice
        
        var url: String {
            switch self {
            case .privacyPolicy:
                return "https://samidare-develop.firebaseapp.com/PrivacyPolicy.html"
            case .termsOfservice:
                return "https://samidare-develop.firebaseapp.com/TermsOfService.html"
            }
        }
    }
    
    enum SheetType {
        case safariView
        case mailer
    }
    
    private let interactor: ConfigInteractor<AppConfigRepository>
    private let router: ConfigRouter<AppConfigRepository, QuestionGroupRepository>
    
    private(set) var selectedExternalLinkType: ExternalLinkType?
    private(set) var sheetType: SheetType?
    
    @Published private(set) var questionGroup: String?
    @Published private(set) var playTime: String?
    @Published var shouldShowSheet = false
    @Published var shouldShowAlert = false
    
    let appVersion: String
    
    init(interactor: ConfigInteractor<AppConfigRepository>, router: ConfigRouter<AppConfigRepository, QuestionGroupRepository>) {
        self.interactor = interactor
        self.router = router
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    func getAppConfig() {
        let appConfig = interactor.getAppConfig()
        questionGroup = appConfig.questionGroupName
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
    
    func didTapSafariViewList(of externalLinkType: ExternalLinkType) {
        self.selectedExternalLinkType = externalLinkType
        sheetType = .safariView
        shouldShowSheet = true
    }
    
    func didTapInquiry() {
        guard MFMailComposeViewController.canSendMail() else {
            shouldShowAlert = true
            return
        }
        sheetType = .mailer
        shouldShowSheet = true
    }
}
