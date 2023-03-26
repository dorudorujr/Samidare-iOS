//
//  GroupAdditionReducer.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/21.
//

import ComposableArchitecture
import SwiftUI

struct GroupAdditionReducer: ReducerProtocol {
    struct State: Equatable {
        var questionAddition: QuestionAdditionReducer.State?
        var groups: [QuestionGroup]?
        var groupToUpdate: QuestionGroup?
        @BindingState var isShowingAddAlert = false
        @BindingState var isShowingUpdateAlert = false
        @BindingState var addGroupBody = ""
        @BindingState var updateGroupBody = ""
        var errorAlert: AlertState<Action>?
        var isQuestionAdditionActive: Bool {
            questionAddition != nil
        }
    }
    
    enum Action: BindableAction, Equatable {
        case questionAddition(QuestionAdditionReducer.Action)
        case binding(BindingAction<State>)
        case onAppear
        case addQuestionGroup
        case update
        case delete(QuestionGroup)
        case questionAdditionDismissed
        case didTapNavBarButton
        case didTapEditSwipeAction(QuestionGroup)
        case didTapRow(QuestionGroup)
        case alertDismissed
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .questionAddition:
                return .none
            case .binding:
                return .none
            case .onAppear:
                FirebaseAnalyticsConfig.sendScreenViewLog(screenName: "\(GroupAdditionView.self)")
                state.groups = questionGroupRepository.get()
                return .none
            case .addQuestionGroup:
                FirebaseAnalyticsConfig.sendEventLog(eventType: .addQuestionGroup)
                do {
                    let questionGroup = QuestionGroup(name: state.addGroupBody)
                    try questionGroupRepository.add(questionGroup)
                    state.groups = questionGroupRepository.get()
                    return .none
                } catch {
                    let errorTitleAndMessage = errorTitleAndMessage(error: error)
                    state.errorAlert = .init {
                        TextState(errorTitleAndMessage.title)
                    } message: {
                        TextState(errorTitleAndMessage.message)
                    }
                    return .none
                }
            case .update:
                FirebaseAnalyticsConfig.sendEventLog(eventType: .editQuestionGroupName)
                guard let groupToUpdate = state.groupToUpdate else {
                    return .none
                }
                do {
                    try questionGroupRepository.add(.init(id: groupToUpdate.id, name: state.updateGroupBody))
                    state.groups = questionGroupRepository.get()
                    return .none
                } catch {
                    let errorTitleAndMessage = errorTitleAndMessage(error: error)
                    state.errorAlert = .init {
                        TextState(errorTitleAndMessage.title)
                    } message: {
                        TextState(errorTitleAndMessage.message)
                    }
                    return .none
                }
            case let .delete(group: group):
                FirebaseAnalyticsConfig.sendEventLog(eventType: .deleteQuestionGroup)
                do {
                    try questionGroupRepository.delete(group)
                    state.groups = questionGroupRepository.get()
                    return .none
                } catch {
                    let errorTitleAndMessage = errorTitleAndMessage(error: error)
                    state.errorAlert = .init {
                        TextState(errorTitleAndMessage.title)
                    } message: {
                        TextState(errorTitleAndMessage.message)
                    }
                    return .none
                }
            case .questionAdditionDismissed:
                state.questionAddition = nil
                return .none
            case .didTapNavBarButton:
                state.isShowingAddAlert = true
                return .none
            case let .didTapEditSwipeAction(group: group):
                state.groupToUpdate = group
                state.updateGroupBody = group.name
                state.isShowingUpdateAlert = true
                return .none
            case let .didTapRow(group: group):
                state.questionAddition = .init(questionGroup: group)
                return .none
            case .alertDismissed:
                state.errorAlert = nil
                return .none
            }
        }
        .ifLet(\.questionAddition, action: /GroupAdditionReducer.Action.questionAddition) {
            QuestionAdditionReducer()
        }
    }
    
    @Dependency(\.questionGroupRepository) private var questionGroupRepository
}

extension GroupAdditionReducer {
    private func errorTitleAndMessage(error: Error) -> (title: String, message: String) {
        if error as? QuestionGroupUniqueError != nil {
            return (title: "", message: L10n.Error.Question.Group.unique)
        } else {
            Log.fault(error, className: String(describing: type(of: self)), functionName: #function)
            return (title: L10n.Error.title, message: L10n.Error.message)
        }
    }
}
