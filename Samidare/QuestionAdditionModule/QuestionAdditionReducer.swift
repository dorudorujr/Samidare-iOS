//
//  QuestionAdditionReducer.swift
//  Samidare
//
//  Created by 杉岡成哉 on 2023/03/15.
//

import ComposableArchitecture
import SwiftUI

struct QuestionAdditionReducer: ReducerProtocol {
    struct State: Equatable {
        let questionGroup: QuestionGroup
        var questions: [Question] = []
        @BindingState var isShowingAddAlert = false
        @BindingState var isShowingUpdateAlert = false
        @BindingState var addQuestionBody = ""
        @BindingState var updateQuestionBody = ""
        var questionToUpdate: Question?
        var errorAlert: AlertState<Action>?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case addQuestion
        case update
        case delete(index: IndexSet)
        case didTapList(question: Question)
        case alertDismissed
        case didTapNavBarButton
        case didTapListRow
        case onDisappear
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                FirebaseAnalyticsConfig.sendScreenViewLog(screenName: "\(GroupAdditionView.self)")
                state.questions = questionRepository.getQuestions(of: state.questionGroup.name)
                return .none
            case .addQuestion:
                FirebaseAnalyticsConfig.sendEventLog(eventType: .addQuestion)
                do {
                    try self.questionRepository.add(.init(body: state.addQuestionBody, group: state.questionGroup))
                    state.questions = questionRepository.getQuestions(of: state.questionGroup.name)
                } catch {
                    state.errorAlert = .init {
                        TextState(L10n.Error.title)
                    } message: {
                        TextState(L10n.Error.message)
                    }
                }
                return .none
            case .update:
                FirebaseAnalyticsConfig.sendEventLog(eventType: .updateQuestion)
                guard let questionToUpdate = state.questionToUpdate else {
                    return .none
                }
                do {
                    try self.questionRepository.update(.init(id: questionToUpdate.id, body: state.updateQuestionBody, group: questionToUpdate.group))
                    state.questions = questionRepository.getQuestions(of: state.questionGroup.name)
                } catch {
                    state.errorAlert = .init {
                        TextState(L10n.Error.title)
                    } message: {
                        TextState(L10n.Error.message)
                    }
                }
                return .none
            case let .delete(index: index):
                FirebaseAnalyticsConfig.sendEventLog(eventType: .deleteQuestion)
                guard let index = index.first, let question = state.questions[safe: index] else {
                    return .none
                }
                do {
                    try self.questionRepository.delete(question)
                    state.questions = questionRepository.getQuestions(of: state.questionGroup.name)
                } catch {
                    state.errorAlert = .init {
                        TextState(L10n.Error.title)
                    } message: {
                        TextState(L10n.Error.message)
                    }
                }
                return .none
            case let .didTapList(question: question):
                state.updateQuestionBody = question.body
                state.isShowingUpdateAlert = true
                state.questionToUpdate = question
                return .none
            case .alertDismissed:
                state.errorAlert = nil
                return .none
            case .didTapNavBarButton:
                state.isShowingAddAlert = true
                return .none
            case .didTapListRow:
                state.isShowingUpdateAlert = true
                return .none
            case .binding:
                return .none
            case .onDisappear:
                return .none
            }
        }
    }
    
    @Dependency(\.questionRepository) private var questionRepository
}
