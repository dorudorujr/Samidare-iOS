//
//  AppConfigSelectionReducer.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/19.
//

import ComposableArchitecture
import SwiftUI

struct AppConfigSelectionReducer: ReducerProtocol {
    struct State: Equatable {
        let type: AppConfigSelectionType
        var questionGroups: [QuestionGroup]?
        var appConfigGameTime: Int?
        var errorAlert: AlertState<Action>?
    }
    
    enum Action: Equatable {
        case onAppear
        case updateQuestionGroup(questionGroup: QuestionGroup)
        case updateGameTime(gameTime: Int)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            if state.type == .questionGroup {
                state.questionGroups = questionGroupRepository.get()
            } else {
                state.appConfigGameTime = appConfigRepository.get().time
            }
            return .none
        case let .updateQuestionGroup(questionGroup: questionGroup):
            FirebaseAnalyticsConfig.sendEventLog(eventType: .changeQuestionGroup)
            precondition(state.type == .questionGroup)
            do {
                let currentAppConfig = appConfigRepository.get()
                let updateAppConfig = AppConfig(questionGroupName: questionGroup.name, time: currentAppConfig.time)
                try appConfigRepository.update(updateAppConfig)
            } catch {
                state.errorAlert = .init {
                    TextState(L10n.Error.title)
                } message: {
                    TextState(L10n.Error.message)
                }
            }
            return .none
        case let .updateGameTime(gameTime: gameTime):
            FirebaseAnalyticsConfig.sendEventLog(eventType: .changeQuestionGroup)
            precondition(state.type == .gameTime)
            do {
                let currentAppConfig = appConfigRepository.get()
                let updateAppConfig = AppConfig(questionGroupName: currentAppConfig.questionGroupName, time: gameTime)
                try appConfigRepository.update(updateAppConfig)
            } catch {
                Log.fault(error, className: String(describing: Swift.type(of: self)), functionName: #function)
                state.errorAlert = .init {
                    TextState(L10n.Error.title)
                } message: {
                    TextState(L10n.Error.message)
                }
            }
            return .none
        }
    }
    
    @Dependency(\.appConfigRepository) private var appConfigRepository
    @Dependency(\.questionGroupRepository) private var questionGroupRepository
}
