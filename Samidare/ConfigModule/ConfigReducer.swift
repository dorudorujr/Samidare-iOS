//
//  ConfigReducer.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/26.
//

import ComposableArchitecture
import SwiftUI
import MessageUI

struct ConfigReducer: ReducerProtocol {
    struct State: Equatable {
        var groupAddition: GroupAdditionReducer.State?
        var questionGroupSelection: AppConfigSelectionReducer.State?
        var gameTimeSelection: AppConfigSelectionReducer.State?
        var questionGroupName = ""
        var playTime = ""
        var selectedExternalLinkType: ExternalLinkType?
        var sheetType: SheetType?
        var shouldShowSheet = false
        var errorAlert: AlertState<Action>?
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    enum Action: Equatable {
        case onAppear
        case groupAddition(GroupAdditionReducer.Action)
        case questionGroupSelection(AppConfigSelectionReducer.Action)
        case gameTimeSelection(AppConfigSelectionReducer.Action)
        case didTapGroupAddition
        case didTapQuestionGroupSelection
        case didTapGameTimeSelection
        case groupAdditionDismissed
        case questionGroupSelectionDismissed
        case gameTimeSelectionDismissed
        case didTapSafariViewRow(externalLinkType: ExternalLinkType)
        case didTapInquiry
        case setSheet(shouldShowSheet: Bool)
        case alertDismissed
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.questionGroupName = appConfigRepository.get().questionGroupName
                state.playTime = appConfigRepository.get().time.description
                return .none
            case .groupAddition, .questionGroupSelection, .gameTimeSelection:
                return .none
            case .didTapGroupAddition:
                state.groupAddition = .init()
                return .none
            case .didTapQuestionGroupSelection:
                state.questionGroupSelection = .init(type: .questionGroup)
                return .none
            case .didTapGameTimeSelection:
                state.gameTimeSelection = .init(type: .gameTime)
                return .none
            case .groupAdditionDismissed:
                state.groupAddition = nil
                return .none
            case .questionGroupSelectionDismissed:
                state.questionGroupSelection = nil
                return .none
            case .gameTimeSelectionDismissed:
                state.gameTimeSelection = nil
                return .none
            case let .didTapSafariViewRow(externalLinkType: externalLinkType):
                state.selectedExternalLinkType = externalLinkType
                state.sheetType = .safariView
                state.shouldShowSheet = true
                return .none
            case .didTapInquiry:
                guard MFMailComposeViewController.canSendMail() else {
                    state.errorAlert = .init {
                        TextState(L10n.Mail.Error.title)
                    } message: {
                        TextState(L10n.Mail.Error.description)
                    }
                    return .none
                }
                state.sheetType = .mailer
                state.shouldShowSheet = true
                return .none
            case .setSheet(shouldShowSheet: true):
                state.shouldShowSheet = true
                return .none
            case .setSheet(shouldShowSheet: false):
                state.shouldShowSheet = false
                return .none
            case .alertDismissed:
                state.errorAlert = nil
                return .none
            }
        }
        .ifLet(\.groupAddition, action: /ConfigReducer.Action.groupAddition) {
            GroupAdditionReducer()
        }
        .ifLet(\.questionGroupSelection, action: /ConfigReducer.Action.questionGroupSelection) {
            AppConfigSelectionReducer()
        }
        .ifLet(\.gameTimeSelection, action: /ConfigReducer.Action.gameTimeSelection) {
            AppConfigSelectionReducer()
        }
    }
    
    @Dependency(\.appConfigRepository) private var appConfigRepository
}

extension ConfigReducer {
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
}
